import Foundation

extension API {
    public enum Endpoint {
        public static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!

        case stories
        case story(Int)

        public var url: URL {
            switch self {
            case .stories:
                return Endpoint.baseURL.appendingPathComponent("newstories.json")
            case .story(let id):
                return Endpoint.baseURL.appendingPathComponent("item/\(id).json")
            }
        }
    }
}
