import Foundation

struct ErrorMessage: Error {
    var message: String
}

extension Operation {
    var isNotCancelled: Bool { !isCancelled }
}

class ResultOperation: Operation {
    var result: Result<Void, Error>?
}

class PrintOperation: ResultOperation {

    private let success: Bool
    private let message: String

    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }

    override func main() {
        guard isNotCancelled
            else { return print("cancelled: \(message)") }

        switch success {
        case false:
            print("failure, message: \(message)")
            result = .failure(ErrorMessage(message: "uh oh, \(message)"))
        case true:
            print("success, message: \(message)")
            result = .success(())
        }
    }
}

class BridgeOperation: Operation {

    private let prev: ResultOperation
    private let next: Operation

    init(prev: ResultOperation, next: Operation) {
        self.prev = prev
        self.next = next
    }

    override func main() {
        guard let result = prev.result
            else { return next.cancel() }

        switch result {
        case .failure:
            print("-> Bridge: previous operation failed, cancelling next operation")
            next.cancel()
        case .success:
            print("-> Bridge: previous operation succeeded")
        }
    }

}

let one = PrintOperation(success: true, message: "1")
let two = PrintOperation(success: true, message: "2")
let three = PrintOperation(success: false, message: "3")

let bridge_1_2 = BridgeOperation(prev: one, next: two)
let bridge_2_3 = BridgeOperation(prev: two, next: three)

bridge_1_2.addDependency(one)
two.addDependency(bridge_1_2)
bridge_2_3.addDependency(two)
three.addDependency(bridge_2_3)

let operations = [one, bridge_1_2, two, bridge_2_3, three]
let queue = OperationQueue()
queue.addOperations(operations, waitUntilFinished: true)
