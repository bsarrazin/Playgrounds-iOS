import Combine
import Foundation

struct Identifier<T>: Equatable {
    var rawValue: String
}

enum Action: Equatable {
    case conversation(Identifier<String>, Context)
    case refreshCredentials
}

extension Action {
    enum Context {
        case externalTap
        case inApp
    }
}

class ActionPublisher {

    // MARK: - Private
    private var subscriptions: Set<AnyCancellable> = []
    let subject: CurrentValueSubject<Action?, Never> = .init(nil)

    // MARK: - Public
    var publisher: AnyPublisher<Action?, Never> { subject.eraseToAnyPublisher() }

    // MARK: - Publishing
    func publish(_ action: Action) {
        subject.send(action)
    }
}

class ViewModel {

    private var subscriptions: Set<AnyCancellable> = []

    init(actionPublisher: ActionPublisher) {
        actionPublisher.publisher
            .compactMap(map)
            .sink(receiveValue: showConversation(id:))
            .store(in: &subscriptions)
    }

    private func map(action: Action?) -> Identifier<String>? {
        guard let action = action
            else { return  nil }

        switch action {
        case .conversation(let conversation, _): return conversation
        default: return nil
        }
    }
    private func showConversation(id: Identifier<String>) {
        print("Navigating to:", id.rawValue)
    }
}

class SessionCoordinator {

    private var subscriptions: Set<AnyCancellable> = []

    init(actionPublisher: ActionPublisher) {
        actionPublisher.publisher
            .filter { $0 == .refreshCredentials }
            .map { _ in () }
            .sink(receiveValue: fetchCredentials)
            .store(in: &subscriptions)
    }

    private func fetchCredentials() {
        print("Fetching the creds")
    }
}

class AppDelegateService {

    private let actionPublisher: ActionPublisher

    init(actionPublisher: ActionPublisher) {
        self.actionPublisher = actionPublisher
    }

    func incomingPush(userInfo: [AnyHashable: Any]) {
        // 1. convert payload to action
        actionPublisher.publish(.conversation(.init(rawValue: "id"), .externalTap))
    }
}

let actionPublisher = ActionPublisher()
//let appDelegateService = AppDelegateService(actionPublisher: actionPublisher)
//
//let repository = SessionCoordinator(actionPublisher: actionPublisher)
//let viewModel = ViewModel(actionPublisher: actionPublisher)
//
//appDelegateService.incomingPush(userInfo: [:])
//appDelegateService.incomingPush(userInfo: [:])


actionPublisher.publish(.refreshCredentials)

let connectable = actionPublisher.publisher
    .buffer(size: 1, prefetch: .keepFull, whenFull: .dropOldest)
    .makeConnectable()

let subscription = connectable
    .compactMap { $0 }
    .sink { print($0) }

connectable.connect()

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
    print(actionPublisher.subject.value)
    connectable.sink { print("got something? \($0)") }
}

//let actions = streamOfActions
//    .buffer(size: 1, prefetch: .keepFull, whenFull: .dropOldest)
//    .makeConnectable()
//actions.sink { action in
//    showModal(for: action)
//}
// instead of delegate = myDelagate
//connection = actions.connect()
// instead of delegate = nil
//connection?.cancel()
//connection = nil
