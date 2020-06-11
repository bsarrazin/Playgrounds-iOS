import Combine
import Foundation

/// There are 2 property wrappers in Combine:
///
/// 1. @Published
///
/// 2. @ObservedObject

example(of: "Published") {
    class Person {
        @Published var age: Int = 0
    }

    let person = Person()
    person.$age.sink { print("New age: \($0)") }

    person.age = 10
}
