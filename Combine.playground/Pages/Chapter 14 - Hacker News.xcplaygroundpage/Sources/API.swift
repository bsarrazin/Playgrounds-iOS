import Combine
import Foundation

public struct API {

    // MARK: - Private
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)

    // MARK: - Public
    public var maxStories: Int

    public init(maxStories: Int = 10) {
        self.maxStories = maxStories
    }

    public func stories() -> AnyPublisher<[Story], Error> {
        URLSession.shared
            .dataTaskPublisher(for: Endpoint.stories.url)
            .map(\.data)
            .decode(type: [Int].self, decoder: decoder)
            .mapError { error -> API.Error in
                switch error {
                case is URLError:
                    return .addressUnreachable(Endpoint.stories.url)
                default:
                    return .invalidResponse
                }
            }
            .filter { !$0.isEmpty }
            .flatMap { self.mergedStories(ids: $0) }
            .scan([]) { stories, story -> [Story] in
                return stories + [story]
            }
            .map { $0.sorted() }
            .eraseToAnyPublisher()
    }
    public func story(id: Int) -> AnyPublisher<Story, Error> {
        URLSession.shared
            .dataTaskPublisher(for: Endpoint.story(id).url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Story.self, decoder: decoder)
            .catch { _ in Empty<Story, Error>() }
            .eraseToAnyPublisher()
    }
    public func mergedStories(ids: [Int]) -> AnyPublisher<Story, Error> {
        let identifiers = Array(ids.prefix(maxStories))

        precondition(!identifiers.isEmpty)

        let initial = story(id: identifiers[0])
        let remainder = Array(identifiers.dropFirst())
        return remainder.reduce(initial) { combined, id in
            return combined
                .merge(with: story(id: id))
                .eraseToAnyPublisher()
        }
    }
}
