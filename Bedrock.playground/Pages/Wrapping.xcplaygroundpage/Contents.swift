import Foundation

// Composing through wrapping

protocol DynamicFeatureStore {
    func value(for key: String, completion: @escaping (String) -> Void)
}

class SplitDynamicFeatureStore: DynamicFeatureStore {
    func value(for key: String, completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            completion(key)
        }
    }
}

class SynchronousDynamicFeatureStore<T: DynamicFeatureStore> {

    private let inner: T

    init(inner: T) {
        self.inner = inner
    }

    func value(for key: String) -> String {

        let group = DispatchGroup()
        group.enter()

        var result: String!
        inner.value(for: key) { value in
            result = value
            group.leaver()
        }

        group.wait()

        return result
    }

}

class CachingSynchronousDynamicFeatureStore {

    private let inner: SynchronousDynamicFeatureStore

    private var cache: [String: String] = [:]

    init(inner: SynchronousDynamicFeatureStore) {
        self.inner = inner
    }

    func value(for key: String, strategy: Strategy) -> String {
        guard cache[key] == nil else {
            return cache[key]
        }

        let result = inner.value(for: key)
        cache[key] = result

        return result
    }

}

let store: DynamicFeatureStore = SynchronousDynamicFeatureStore(inner: SplitDynamicFeatureStore())

let result1 = store.value(for: "key", strategy: .cacheOnlyAndFetch)

protocol SomeSideEffectDFS {

}

class SplitSSEDFS: SomeSideEffectDFS {
    inner
}


let egg = ThreePoundsEgg(RedEgg(Egg()))
