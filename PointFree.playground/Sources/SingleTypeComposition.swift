import Foundation


precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

public func <> <T>(input: @escaping (T) -> T, output: @escaping (T) -> T) -> (T) -> T {
    return input >>> output
}
public func <> <T>(input: @escaping (inout T) -> Void, output: @escaping (inout T) -> Void) -> (inout T) -> Void {
    return { t in
        input(&t)
        output(&t)
    }
}

public func |> <T>(input: inout T, transform: (inout T) -> Void) {
    transform(&input)
}
