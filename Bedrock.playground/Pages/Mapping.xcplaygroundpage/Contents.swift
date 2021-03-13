import Foundation
import UIKit

struct KeyPath {
    var segments: [String]
    var isEmpty: Bool { return segments.isEmpty }
    var path: String { return segments.joined(separator: ".") }
    
    func headAndTail() -> (head: String, tail: KeyPath)? {
        guard !isEmpty else { return nil }
        var tail = segments
        let head = tail.removeFirst()
        return (head, KeyPath(segments: tail))
    }
}

extension KeyPath {
    init(_ string: String) {
        segments = string.components(separatedBy: ".")
    }
}

extension KeyPath: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

extension Dictionary where Key == String {
    subscript(keyPath keyPath: KeyPath) -> Any? {
        get {
            switch keyPath.headAndTail() {
            case nil: // key path is empty.
                return nil
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty: // Reached the end of the key path.
                return self[head]
            case let (head, remainingKeyPath)?: // Key path has a tail we need to traverse.
                switch self[head] {
                case let nestedDict as [Key: Any]: // Next nest level is a dictionary. Start over with remaining key path.
                    return nestedDict[keyPath: remainingKeyPath]
                default: // Start over with remaining key path. Invalid key path, abort.
                    return nil
                }
            }
        }
        set {
            switch keyPath.headAndTail() {
            case nil: // key path is empty.
                return
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty: // Reached the end of the key path.
                self[head] = newValue as? Value
            case let (head, remainingKeyPath)?:
                let value = self[head]
                switch value {
                case var nestedDict as [Key: Any]: // Key path has a tail we need to traverse
                    nestedDict[keyPath: remainingKeyPath] = newValue
                    self[head] = nestedDict as? Value
                default: // Invalid keyPath
                    return
                }
            }
        }
    }
}

let d: [String: Any] = [
    "hello": "world",
    "foo": [
        "hello": "world",
        "baz": 42
    ]
]

let kp: KeyPath = "foo.baz"
d[keyPath: "foo.baz"]

func foo(_ strings: String ..., int: Int) {
    print(strings)
    print(int)
}

foo("hello", "world", int: 0)
