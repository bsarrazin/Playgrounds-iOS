import Foundation
import XCTest

func compute(_ x: Int) -> Int {
    return x * x + 1
}

compute(2)
compute(2)
compute(2)

assert(5, equals: compute(2))
assert(5, equals: compute(3))
assert(6, equals: compute(2))

func computeSideEffect(_ x: Int) -> Int {
    let result = x * x + 1

    print("Computed: \(result)")
    
    return result
}

computeSideEffect(2)

assert(5, equals: computeSideEffect(2))

[2, 10].map(compute).map(compute)
[2, 10].map(compute >>> compute)

[2, 10].map(computeSideEffect).map(computeSideEffect)
[2, 10].map(computeSideEffect >>> computeSideEffect)

func computeAndPrint(_ x: Int) -> (Int, [String]) {
    let result = x * x + 1
    return (result, ["Computed: \(result)"])
}

___
computeAndPrint(2)

assert((5, ["Computed: 5"]), equals: computeAndPrint(2))
assert((3, ["Computed: 6"]), equals: computeAndPrint(3))

let (computation, logs) = computeAndPrint(2)
___
logs.forEach { print($0) }

compute >>> compute
computeSideEffect >>> computeSideEffect
// computeAndPrint >>> computeAndPrint // ❗️ doesn't compile

func compose<A, B, C>(
    _ f1: @escaping (A) -> (B, [String]),
    _ f2: @escaping (B) -> (C, [String])
) -> ((A) -> (C, [String])) {
    return { a in
        let (b, logs) = f1(a)
        let (c, more) = f2(b)
        return (c, logs + more)
    }
}

2 |> compose(computeAndPrint, computeAndPrint)
2 |> compose(compose(computeAndPrint, computeAndPrint), computeAndPrint)
2 |> compose(computeAndPrint, compose(computeAndPrint, computeAndPrint))

//precedencegroup EffectfulComposition {
//    associativity: left
//    higherThan: ForwardApplication
//    lowerThan: ForwardComposition
//}
//
//infix operator >=>: EffectfulComposition
//
//func >=> <A, B, C>(
//    _ f1: @escaping (A) -> (B, [String]),
//    _ f2: @escaping (B) -> (C, [String])
//) -> ((A) -> (C, [String])) {
//    return { a in
//        let (b, logs) = f1(a)
//        let (c, more) = f2(b)
//        return (c, logs + more)
//    }
//}

2 |> computeAndPrint
    >=> increment
    >>> computeAndPrint
    >=> square
    >>> computeAndPrint

//func >=> <A, B, C>(
//    _ f1: @escaping (A) -> B?,
//    _ f2: @escaping (B) -> C?
//) -> ((A) -> C?) {
//    return { a in
//        fatalError()
//    }
//}

func greetWithEffect(_ name: String) -> String {
    let seconds = Int(Date().timeIntervalSince1970) % 60
    return "Hello \(name)! It's \(seconds) seconds past the minute."
}

greetWithEffect("Ben")

func greet(at date: Date = .init(), name: String) -> String {
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name)! It's \(seconds) seconds past the minute."
}

greet(name: "Ben")
assert("Hello Ben! It's 39 seconds past the minute.", equals: greet(at: Date(timeIntervalSince1970: 39), name: "Ben"))

func uppercased(_ string: String) -> String {
    return string.uppercased()
}

func greet(at date: Date) -> (String) -> String {
    return { name in
        let seconds = Int(date.timeIntervalSince1970) % 60
        return "Hello \(name)! It's \(seconds) seconds past the minute."
    }
}

"Bob" |> greet(at: Date()) >>> uppercased
"Bob" |> uppercased >>> greet(at: Date())

assert("Bob" |> uppercased >>> greet(at: .init(timeIntervalSince1970: 24)), equals: "Hello BOB! It's 24 seconds past the minute.")

___
___


// MARK: - Mutations

let formatter = NumberFormatter()

func currencyStyle(_ formatter: NumberFormatter) {
    formatter.numberStyle = .currency
    formatter.roundingMode = .down
}
func decimalStyle(_ formatter: NumberFormatter) {
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
}
func wholeStyle(_ formatter: NumberFormatter) {
    formatter.maximumFractionDigits = 0
}

decimalStyle(formatter)
wholeStyle(formatter)
formatter.string(from: 1234.6)

currencyStyle(formatter) // 💥 implicit side effect from rounding down
formatter.string(from: 1234.6)

decimalStyle(formatter)
wholeStyle(formatter)
formatter.string(from: 1234.6)


struct NumberFormatterConfig {
    var style: NumberFormatter.Style = .none
    var roundingMode: NumberFormatter.RoundingMode = .up
    var maxFractionDigits: Int = 0
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.roundingMode = roundingMode
        formatter.maximumFractionDigits = maxFractionDigits
        return formatter
    }
}

func currencyStyle(_ config: NumberFormatterConfig) -> NumberFormatterConfig {
    var config = config
    config.style = .currency
    config.roundingMode = .down
    return config
}
func decimalStyle(_ config: NumberFormatterConfig) -> NumberFormatterConfig {
    var config = config
    config.style = .decimal
    config.maxFractionDigits = 2
    return config
}
func wholeStyle(_ config: NumberFormatterConfig) -> NumberFormatterConfig {
    var config = config
    config.maxFractionDigits = 0
    return config
}

wholeStyle(decimalStyle(NumberFormatterConfig()))
    .formatter
    .string(from: 1234.6)

wholeStyle(currencyStyle(NumberFormatterConfig()))
    .formatter
    .string(from: 1234.6)

wholeStyle(decimalStyle(NumberFormatterConfig()))
    .formatter
    .string(from: 1234.6)


func inoutCurrencyStyle(_ config: inout NumberFormatterConfig) {
    config.style = .currency
    config.roundingMode = .down

}
func inoutDecimalStyle(_ config: inout NumberFormatterConfig) {
    config.style = .decimal
    config.maxFractionDigits = 2

}
func inoutWholeStyle(_ config: inout NumberFormatterConfig) {
    config.maxFractionDigits = 0
}

var config = NumberFormatterConfig()

inoutDecimalStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(from: 1234.6)

inoutCurrencyStyle(&config)
config.formatter.string(from: 1234.6)

inoutDecimalStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(from: 1234.6)


func toInOut<T>(_ transform: @escaping (T) -> T) -> (inout T) -> Void {
    return { t in t = transform(t) }
}

func fromInOut<T>(_ transform: @escaping (inout T) -> Void) -> (T) -> T {
    return {
        var t = $0
        transform(&t)
        return t
    }
}

config |> decimalStyle <> currencyStyle
config.maxFractionDigits
config.roundingMode
config.style

config |> inoutDecimalStyle <> inoutCurrencyStyle
config.maxFractionDigits
config.roundingMode
config.style

