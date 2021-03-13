import Foundation
import PlaygroundSupport
import UIKit

class NeverEndingOperation: Operation {
    override func main() {
        print("Counting")
    }
}

class ConcurrentOperation: Operation {
    override var isConcurrent: Bool { return true }
    override var isAsynchronous: Bool { return true }
    var _finished = false
    override var isFinished: Bool { return _finished }
    
    override func start() {
        print("Starting...")
        print("Stopping...")
        _finished = true
    }
}

example("Basic Queues") { _ in
    func displayOperationCount(_ queue: OperationQueue) {
        print("queue count = \(queue.operationCount)")
    }
    
    let queue = OperationQueue()
    queue.addOperations([NeverEndingOperation(), ConcurrentOperation()], waitUntilFinished: false)
    
    displayOperationCount(queue)
    queue.waitUntilAllOperationsAreFinished()
    displayOperationCount(queue)
}

class CountOperation: Operation {
    static var count: Int = 0
    override func main() {
        print("\(CountOperation.self): \(#function) -> \(CountOperation.count)")
        CountOperation.count += 1
    }
}

example("Sync Machine") { _ in
    let name = "Playground"
    let timeInterval: TimeInterval = 3
    let backgroundQueue = makeBackgroundQueue(name)
    let syncQueue = makeSyncQueue(name)
    let utilityQueue = makeUtilityQueue(name)
    let utmostImportanceQueue = makeUtmostImportanceQueue(name)
    let machine = SyncMachine(backgroundQueue: backgroundQueue,
                              syncQueue: syncQueue,
                              utilityQueue: utilityQueue,
                              utmostImportanceQueue: utmostImportanceQueue,
                              timeInterval: timeInterval)
    
    machine.start(withRecurringOperationTypes: [CountOperation.self])
    
    dispatch(.seconds(10)) {
        print(CountOperation.count)
        print("nb of operations: \(syncQueue.operationCount)")
        syncQueue.operations.forEach {
            print("operation is finished? \($0.isFinished)")
        }
        machine.cancelAllOperationsAndReset()
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

