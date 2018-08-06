import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

public class BinaryNode<Element> {
    var value: Element
    var left: BinaryNode?
    var right: BinaryNode?
    
    init(value: Element) {
        self.value = value
    }
}

extension BinaryNode: CustomStringConvertible {
    public var description: String {
        return diagram(for: self)
    }
    
    private func diagram(for node: BinaryNode?, _ top: String = "", _ root: String = "", _ bottom: String = "") -> String {
        guard let node = node
            else { return root + "nil\n" }
        
        if node.left == nil && node.right == nil {
            return root + "\(node.value)\n"
        }
        
        return diagram(for: node.right, top + " ", top + "┌──", top + "| ")
            + root + "\(node.value)\n"
            + diagram(for: node.left, bottom + "| ", bottom + "└──", bottom + " ")
    }
}

extension BinaryNode {
    func traverseInOrder(visit: (Element?) -> Void) {
        left?.traverseInOrder(visit: visit)
        visit(value)
        right?.traverseInOrder(visit: visit)
    }
    
    func traversePreOrder(visit: (Element?) -> Void) {
        visit(value)
        left?.traversePreOrder(visit: visit)
        right?.traversePreOrder(visit: visit)
    }
    
    func traversePostOrder(visit: (Element?) -> Void) {
        left?.traversePostOrder(visit: visit)
        right?.traversePostOrder(visit: visit)
        visit(value)
    }
    
    func height() -> Int {
        return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
    }
}

protocol BinaryNodeDecoder {
    func decode<T>(from string: String) -> BinaryNode<T>?
}
protocol BinaryNodeEncoder {
    func encode<T>(_ node: BinaryNode<T>?) throws -> String
}

class BinaryNodeCoder: BinaryNodeDecoder, BinaryNodeEncoder {
    
    private let separator: Character = ","
    private let nilNode = "X"
    
    func decode<T>(from string: String) -> BinaryNode<T>? {
        var components = string.split(separator: separator).reversed().map(String.init)
        return decode(from: &components)
    }
    
    private func decode<T>(from array: inout [String]) -> BinaryNode<T>? {
        guard !array.isEmpty else { return nil }
        
        let value = array.removeLast()
        
        value
        guard value != nilNode, let val = value as? T else { return nil }
        
        let node = BinaryNode<T>(value: val)
        node.left = decode(from: &array)
        node.right = decode(from: &array)
        
        return node
    }
    
    func encode<T>(_ node: BinaryNode<T>?) throws -> String {
        var str = ""
        node?.traversePreOrder { data in
            if let data = data {
                let string = String(describing: data)
                str += string
            } else {
                str += nilNode
            }
            str.append(separator)
        }
        
        return str
    }
}

var tree: BinaryNode<Int> {
    let zero = BinaryNode(value: 0)
    let one = BinaryNode(value: 1)
    let five = BinaryNode(value: 5)
    let seven = BinaryNode(value: 7)
    let eight = BinaryNode(value: 8)
    let nine = BinaryNode(value: 9)
    
    seven.left = one
    one.left = zero
    one.right = five
    seven.right = nine
    nine.left = eight
    
    return seven
}

example("tree diagram") { _ in
    print(tree)
}

example("in-order traversal") { _ in
    tree.traverseInOrder(visit: { print($0!) })
}

example("pre-order traversal") { _ in
    tree.traversePreOrder(visit: { print($0!) })
}

example("post-order traversal") { _ in
    tree.traversePostOrder(visit: { print($0!) })
}

example("height") { _ in
    print(tree.height())
}

example("encoding and decoding") { _ in
    let coder = BinaryNodeCoder()
    let encoded = try! coder.encode(tree)
    print(encoded)
    let decoded: BinaryNode<Int>? = coder.decode(from: encoded)
    print(decoded)
}
