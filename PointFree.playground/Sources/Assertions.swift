import Foundation

@discardableResult
public func assert<T: Equatable>(_ value: T, equals: T) -> String {
    return value == equals ? "✅" : "❗️"
}

@discardableResult
public func assert<A: Equatable, B: Equatable>(_ value: (A, B), equals: (A, B)) -> String {
  return value == equals ? "✅" : "❗️"
}
