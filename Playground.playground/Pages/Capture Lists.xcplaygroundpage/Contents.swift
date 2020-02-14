import Foundation

class Logger {
    func log() { }
}

class DataStore {
    func upsert() { }
}

class APIClient {
    func perform(_ completion: @escaping () -> Void) {

    }
}

class ViewModel {

    private let apiClient: APIClient
    private let logger: Logger
    private let dataStore: DataStore

    init(apiClient: APIClient, dataStore: DataStore, logger: Logger) {
        self.apiClient = apiClient
        self.dataStore = dataStore
        self.logger = logger
    }

    func foo() { // 💥 don't do this
        apiClient.perform { [weak self] in
            self?.logger.log() // could be not nil
            self?.dataStore.upsert() // could be nil
        }
    }
    func bar() {
        apiClient.perform { [weak self] in
            guard let self = self else { return }
            self.logger.log()
            self.dataStore.upsert()
            self.foooo()
        }
    }
    func baz() {
        apiClient.perform { [dataStore, logger] in
            logger.log()
            dataStore.upsert()
        }
    }
    func foooo() { }

}

