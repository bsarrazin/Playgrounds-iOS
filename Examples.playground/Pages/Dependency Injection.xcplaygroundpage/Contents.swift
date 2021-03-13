import Foundation

//struct Name<T>: Hashable, RawRepresentable {
//    var rawValue: String
//}
//
//extension Name {
//    static var `default`: Name { .init(rawValue: #function) }
//}
//
//struct Lifetime<T> {
//    typealias Factory = () throws -> T
//
//    let resolver: (Factory) throws -> T
//
//    init(resolver: @escaping (Factory) throws -> T) {
//        self.resolver = resolver
//    }
//}
//
//private func keep<T>(instance: inout T?, or makeOne: Lifetime<T>.Factory) rethrows -> T {
//    instance = try instance ?? makeOne()
//    return instance!
//
//}
//
//extension Lifetime {
//    static var singleton: Lifetime {
//        var instance: T?
//        return .init { try keep(instance: &instance, or: $0) }
//    }
//    static var unique: Lifetime {
//        .init { try $0() }
//    }
//}
//
//class Container {
//    typealias Resolver = (Container, Any) throws -> Any
//
//    static let `default`: Container = .init()
//
//    private init() { }
//
//    private var resolvers: [String: Resolver] = [:]
//    private var resolving: [String: Int] = [:]
//    private let lock = NSRecursiveLock()
//
//    // MARK: - Container
//    func register<T, Parameter>(_: T.Type, name: Name<T> = .default, lifetime: Lifetime<T>, resolver: @escaping (Container, Parameter) throws -> T) -> Container {
//        let id = makeId(T.self, from: name)
//
//        let locking = Lifetime<T> { [unowned self] original in
//            self.lock.lock(); defer { self.lock.unlock() }
//
//            if (self.resolving[id] ?? 0) > 0 {
//                throw Error.circularResolution
//            } else {
//                let count = self.resolving[id] ?? 0
//                self.resolving[id] = count + 1
//            }
//
//            let instance = try lifetime.resolver(original)
//            let count = self.resolving[id] ?? 0
//            self.resolving[id] = count - 1
//
//            return instance
//        }
//
//        resolvers[id] = { container, parameter in
//            switch parameter as? Parameter {
//            case let parameter?: return try locking.resolver({ try resolver(container, parameter) })
//            default: throw Error.invalidParameterType
//            }
//        }
//
//        return self
//    }
//    @discardableResult
//    func register<T>(_: T.Type, name: Name<T> = .default, lifetime: Lifetime<T>, resolver: @escaping (Container) throws -> T) -> Container {
//        return register(T.self, name: name, lifetime: lifetime) { (container, _: NoParameter) -> T in
//            return try resolver(container)
//        }
//    }
//    func resolve<T, Parameter>(_: T.Type, name: Name<T>, parameter: Parameter) throws -> T {
//        guard let resolver = resolvers[makeId(T.self, from: name)] else {
//            throw Error.notFound
//        }
//        return try resolver(self, parameter) as! T
//    }
//    func resolve<T>(_: T.Type = T.self, name: Name<T> = .default) throws -> T {
//        return try resolve(T.self, name: name, parameter: NoParameter())
//    }
//
//    // MARK: - Support
//    private func makeId<T>(_: T.Type, from name: Name<T>) -> String {
//        return "\(String(describing: T.self)):\(name.rawValue)"
//    }
//}
//
//
//class A {
//    let name: String
//    init(name: String) {
//        self.name = name
//    }
//}
//
//Container.default.register(A.self, lifetime: .singleton) { _ in
//    return A(name: "a")
//}
//
//let a = try Container.default.resolve(A.self)
//a.name
//
//class B {
//    let int: Int
//    init(int: Int) {
//        self.int = int
//    }
//}
//
//Container.default.register(B.self, lifetime: .unique) { _ in
//    let int = Array(0..<100).randomElement()!
//    return B(int: int)
//}
//
//try Container.default.resolve(B.self).int
//try Container.default.resolve(B.self).int
//try Container.default.resolve(B.self).int
//try Container.default.resolve(B.self).int
//try Container.default.resolve(B.self).int
//
//3
//
//class C {
//    let name: String
//    init(name: String) {
//        self.name = name
//    }
//}
//
//Container.default
//    .register(C.self, lifetime: .singleton) { _ in
//        return C(name: "C")
//    }
//    .register(C.self, name: .init(rawValue: "foo"), lifetime: .singleton) { _ in
//        return C(name: "foo")
//    }
//
//class D {
//    @Dependency(container: .default, name: .init(rawValue: "foo")) var c: C
//}
//
//D().c.name


// Inside GDKit's Dependencies Module
class Dependencies {
    func resolve<T>(_:T.Type) throws -> T { }
}
struct Assembly {
    var register: (Dependencies) -> Void
}


// Inside MyAwesomeModule
extension Assembly {
    static var myAwesomeModule: Assembly {
        .init { container in
            container.register(DataStore.self, named: .init(rawValue: "My Awesome Module"), strategy: .unique) { _ in
                return InMemoryDataStore()
            }
        }
    }
    static var yourAwesomeModule: Assembly {
        .init { container in
            precondition(try? container.resolve(DataStore.self) != nil, "Expected DataStore to be registered")
            container.register(VieModel.self, , strategy: .unique) { _ in
                let store: DataStore = try $0.resolve()
                let sso = store.value(SSOToken.self)
                return .init(token: sso.jwt)
            }
        }
    }
}


// Inside App

func didFinishLaunching() {
    let container: Dependencies = .default
    Assembly.myAwesomeModule.register(container)
    Assembly.yourAwesomeModule.register(container)
    Assembly.theirAwesomeModule.register(container)

    container.register(DataStore.self, named: .default, strategy: .singleton) {

    }


}
