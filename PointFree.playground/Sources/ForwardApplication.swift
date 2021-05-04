import Foundation

precedencegroup ForwardApplication {
    associativity: left
    higherThan: ForwardComposition
}

infix operator |>: ForwardApplication

public func |> <Input, Output>(input: Input, transform: (Input) -> Output) -> Output {
    return transform(input)
}
