import Foundation

class Logger {
    func log() { }
}

class DataStore {
    func upsert() { }
}

class APIClient {
    func perform(_ completion: @escaping () -> Void) { }
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

    func foo() {
        apiClient.perform {
            self.logger.log()
            self.dataStore.upsert()
        }
    }
}

// Can you spot the problem?
// How would you fix it?
