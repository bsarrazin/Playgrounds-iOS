import Foundation

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

/// <#Description#>
/// - Parameters:
///   - f1: <#f1 description#>
///   - f2: <#f2 description#>
/// - Returns: <#description#>
public func >>> <A, B, C>(
    f1: @escaping (A) -> B,
    f2: @escaping (B) -> C
) -> ((A) -> C) {
    return { f2(f1($0)) }
}
