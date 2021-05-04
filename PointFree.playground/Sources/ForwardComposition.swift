import Foundation

precedencegroup ForwardComposition {
    associativity: left
    higherThan: EffectfulComposition
}

infix operator >>>: ForwardComposition

public func >>> <Input, Intermediary, Output>(input: @escaping (Input) -> Intermediary, intermediary: @escaping (Intermediary) -> Output) -> ((Input) -> Output) {
    return { intermediary(input($0)) }
}
