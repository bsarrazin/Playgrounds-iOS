import Foundation

// MARK: - Using Functions

increment(2)
square(increment(2))


// MARK: - Using Methods

extension Int {
    func increment() -> Int { self + 1 }
    func square() -> Int { self * self }
}

2.increment().square()




// MARK: - Using Custom Operator

// See ForwardApplication.swift
2 |> increment
2 |> increment |> square

// See ForwardComposition.swift
increment >>> square
square >>> increment

(increment >>> square)(2)

2 |> increment >>> square

extension Int {
    func incrementSquare() -> Int {
        self.increment().square()
    }
}

2.incrementSquare()

increment >>> square >>> String.init

[1, 2, 3]
    .map { ($0 + 1) * ($0 + 1) }

[1, 2, 3]
    .map(increment >>> square)
