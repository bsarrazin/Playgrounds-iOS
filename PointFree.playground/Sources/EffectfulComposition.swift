import Foundation

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >=>: EffectfulComposition

public func >=> <A, B, C>(_ f1: @escaping (A) -> (B, [String]), _ f2: @escaping (B) -> (C, [String])) -> ((A) -> (C, [String])) {
    return { a in
        let (b, logs) = f1(a)
        let (c, more) = f2(b)
        return (c, logs + more)
    }
}

public func >=> <A, B, C>(_ f1: @escaping (A) -> B?, _ f2: @escaping (B) -> C?) -> ((A) -> C?) {
    return { a in
        fatalError()
    }
}
