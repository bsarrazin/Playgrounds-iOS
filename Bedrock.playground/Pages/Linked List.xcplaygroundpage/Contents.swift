import Foundation

class Node<T> {
    // MARK: - Properties
    let value: T
    
    // MARK: - List Navigation
    weak var previous: Node?
    var next: Node?
    
    // MARK: - Lifecycle
    init(value: T) {
        self.value = value
    }
}

struct LinkedList<T> {
    // MARK: - Properties
    private(set) var head: Node<T>?
    private(set) var tail: Node<T>?
    
    var isEmpty: Bool { return head == nil }
    var first: Node<T>? { return head }
    var last: Node<T>? { return tail }
    
    mutating func append(_ value: T) {
        append(Node(value: value))
    }
    
    private mutating func append(_ node: Node<T>) {
        switch tail {
        case .none:
            head = node
        case .some:
            node.previous = tail
            tail?.next = node
        }
        
        tail = node
    }
    
    func node(at index: Int) -> Node<T>? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }
    
    mutating func removeAll() {
        head = nil
        tail = nil
    }
    
    mutating func remove(node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        
        next?.previous = prev
        
        if next == nil {
            tail = prev
        }
        
        node.previous = nil
        node.next = nil
        
        return node.value
    }
    
    mutating func insert(node: Node<T>, at index: Int) {
        guard let existing = self.node(at: index)
            else { append(node); return }
        
        if let prev = existing.previous {
            prev.next = node
            node.next = existing
            existing.previous = node
        }
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        var items: [String] = []
        var node = head
        while node != nil {
            items.append("\(node!.value)")
            node = node?.next
        }
        return items.joined(separator: ", ")
    }
}

var list = LinkedList<String>()
list.append("Labrador")
list.append("Bulldog")
list.append("Beagle")
list.append("Husky")
print(list)

list.node(at: 3)?.value

if let node = list.node(at: 0) {
    list.remove(node: node)
    print(list)
}

list.insert(node: Node(value: "Hello, World!"), at: 1)
print(list)
