import Foundation

// Composing through wrapping

protocol DataStore {
    func upsert(completion: () -> Void)
}

class InMemoryDataStore: DataStore {
    func upsert(completion: () -> Void) {
        completion()
    }
}

class SynchronousDataStore: DataStore {
    let inner: DataStore

    init(inner: DataStore) {
        self.inner = inner
    }
    func upsert(completion: () -> Void) {
        let group = DispatchGroup()
        group.enter()

        inner.upsert {
            group.leave()
        }

        group.wait()
    }
}
