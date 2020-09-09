import Foundation

// 1. Use `Operation` and `OperationQueue`
//
// 2. Consider these steps:
//   a) get authenticated S3 url
//   b) upload image to S3
//   c) send SMS message with image
//
// 3. Order of operations is important
//
// 4. If any of the operations fail, the following operations must _not_ be performed
//
// 5. Considering a+b+c as a transaction, multiple transactions can be sent simultaneously





















































































class BridgeOperation<PrevInput, BridgeType, NextOutput>: Operation {

    typealias PreviousOp = BridgeableOperation<PrevInput, BridgeType, Error>
    typealias NextOp = BridgeableOperation<BridgeType, NextOutput, Error>

    private let prev: PreviousOp
    private let next: NextOp

    init(prev: PreviousOp, next: NextOp) {
        self.prev = prev
        self.next = next
        super.init()

        self.addDependency(prev)
        next.addDependency(self)
    }

    override func main() {
        guard let result = prev.output else {
            print("Previous operation \(String(describing: prev)) did not have a result")
            print("Cancelling next operation \(String(describing: next))")
            return next.cancel()
        }

        switch result {
        case .failure(let error):
            print("Previous operation \(String(describing: prev)) failed with error: \(error)")
            print("Cancelling next operation \(String(describing: next))")
            next.cancel()
        case .success(let success):
            next.input = success
            print("Previous operation \(String(describing: prev)) succeeded")
            print("Next operation: \(String(describing: next))")
        }
    }

}

class BridgeableOperation<Input, Output, Failure: Error>: Operation {

    // MARK: - Subtypes
    enum BridgeableError: Error {
        case isCancelled
    }

    // MARK: - Properties
    var output: Result<Output, Failure>?
    var input: Input?

    override func main() {
        guard !isCancelled else {
            let message = "\(String(describing: self)) will not run because it has been cancelled"
            return print(message)
        }
    }
}

extension String: Error { }

class Operation1: BridgeableOperation<Void, String, Error> {
    override func main () {
        super.main()

        guard !isCancelled
            else { return }

        print("Running operation 1")

        output = .success("Success")
        // output = .failure("Error")
    }
}

class Operation2: BridgeableOperation<String, String, Error> {
    override func main () {
        super.main()

        guard !isCancelled
            else { return }

        print("Running operation 2")

        output = .success("Success")
        // output = .failure("Error")
    }
}

class Operation3: BridgeableOperation<String, String, Error> {
    override func main () {
        super.main()

        guard !isCancelled
            else { return }

        print("Running operation 3")

        output = .success("Success")
        // output = .failure("Error")
    }
}

let op1 = Operation1()
let op2 = Operation2()
let op3 = Operation3()
let from1To2 = BridgeOperation(prev: op1, next: op2)
let from2To3 = BridgeOperation(prev: op2, next: op3)

let queue = OperationQueue()
queue.addOperations([op1, op2, op3, from1To2, from2To3], waitUntilFinished: false)




