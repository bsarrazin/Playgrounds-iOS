import Combine
import Foundation

struct Payload { }
struct Request { }

enum Action {
    case nav(Payload)
    case appsync(Request)
}

class ActionHandler {
    func handle(action: Action) {
        print("Handling action!")
    }
}

class ActionPublisher {

    // MARK: - Private
    private var subscriptions: Set<AnyCancellable> = []
    private let subject: PassthroughSubject<Action, Never> = .init()

    // MARK: - Public
    var publisher: AnyPublisher<Action, Never> { subject.eraseToAnyPublisher() }

    init(handler: ActionHandler) {
        subject
            .sink { handler.handle(action: $0) }
            .store(in: &subscriptions)
    }

    func publish(_ action: Action) {
        subject.send(action)
    }
}

class ViewModel {

    private var subscriptions: Set<AnyCancellable> = []

    init(ap: ActionPublisher) {
        ap.publisher
            .filter { action in
                switch action {
                case .nav: return true
                default: return false
                }
            }
            .sink { _ in print("Navigating to...") } // actually perform the UI nav
            .store(in: &subscriptions)
    }
}


class Repository {

    private var subscriptions: Set<AnyCancellable> = []

    init(ap: ActionPublisher) {
        ap.publisher
            .filter { action in
                switch action {
                case .appsync: return true
                default: return false
                }
            }
            .sink { _ in print("Fetching the creds") } // fetch the creds
            .store(in: &subscriptions)
    }
}

let actionHandler = ActionHandler()
let actionPublisher = ActionPublisher(handler: actionHandler)

let repository = Repository(ap: actionPublisher)
let viewModel = ViewModel(ap: actionPublisher)

actionPublisher.publish(.appsync(.init()))
actionPublisher.publish(.nav(.init()))
