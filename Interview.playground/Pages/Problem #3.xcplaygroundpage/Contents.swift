// MARK: - Protocol
protocol P {
    func method() -> String
}
extension P {
    func method() -> String { return "in protocol" }
}

// MARK: - Struct
struct S: P {
}
extension S {
    func method() -> String { return "in struct" }
}

let s = S()
let p: P = s

s.method() // what is printed here?
p.method() // what is printed here?

// why?
