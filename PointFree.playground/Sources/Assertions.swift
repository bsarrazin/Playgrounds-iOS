import Foundation

@discardableResult
public func assert<T: Equatable>(_ value: T, equals: T) -> String {
    let passes = value == equals
    let result = passes ? "✅" : "❗️"
    guard passes else {
        print("\(result) value: \(value), does not equal: \(equals)")
        return result
    }
    return result
}

@discardableResult
public func assert<A: Equatable, B: Equatable>(_ value: (A, B), equals: (A, B)) -> String {
    let passes = value == equals
    let result = passes ? "✅" : "❗️"
    guard passes else {
        print("\(result) value: \(value), does not equal: \(equals)")
        return result
    }
    return result
}
