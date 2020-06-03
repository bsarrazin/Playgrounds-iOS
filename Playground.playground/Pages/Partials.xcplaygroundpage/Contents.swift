import Foundation

@dynamicMemberLookup
struct Combined<A, B> {

    private let a: A
    private let b: B

    init(a: A, b: B) { (self.a, self.b) = (a, b) }

    subscript<T>(dynamicMember keyPath: KeyPath<A, T>) -> T {
        return a[keyPath: keyPath]
    }
    subscript<T>(dynamicMember keyPath: KeyPath<B, T>) -> T {
        return b[keyPath: keyPath]
    }
}

struct SSOToken {
    var id: String
    var token: String
}

struct User {
    var name: String
    var age: Int
}

struct Subscription {
    var newsletter: Bool
    var music: Bool
}

typealias Step1 = Combined<Void, SSOToken>
typealias Step2 = Combined<Step1, User>
typealias Step3 = Combined<Step2, Subscription>

let step1 = Step1(
    a: (),
    b: .init(
        id: "abcd1234",
        token: "123xyz"
    )
)

let step2 = Step2(
    a: step1,
    b: .init(
        name: "Ben",
        age: 42
    )
)

let step3 = Step3(
    a: step2,
    b: .init(
        newsletter: false,
        music: true
    )
)

print("SSOToken.id:", step3.id)
print("SSOToken.token:", step3.token)
print("User.name:", step3.name)
print("User.age:", step3.age)
print("Subscription.newsletter:", step3.newsletter)
print("Subscription.music:", step3.music)
