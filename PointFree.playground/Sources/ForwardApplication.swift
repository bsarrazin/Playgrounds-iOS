import Foundation

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

/// <#Description#>
/// - Parameters:
///   - a: <#a description#>
///   - f: <#f description#>
/// - Returns: <#description#>
public func |> <A, B>(
    a: A,
    f: (A) -> B
) -> B { f(a) }
