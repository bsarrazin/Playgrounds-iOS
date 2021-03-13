import Foundation
import UIKit

public class SyncMachine {
    
    public enum Category {
        case background
        case sync
        case utility
        case utmostImportance
    }
    
    public var currentOperationTypes: [Operation.Type] { return operationTypes }
    public var currentTimer: Timer? { return timer }
    private var operationTypes: [Operation.Type] = []
    private let timeInterval: TimeInterval
    private var timer: Timer?
    private let backgroundQueue: OperationQueue
    private let syncQueue: OperationQueue
    private let utilityQueue: OperationQueue
    private let utmostImportanceQueue: OperationQueue
    
    public init(_ operations: [Operation]? = nil, backgroundQueue: OperationQueue, syncQueue: OperationQueue, utilityQueue: OperationQueue, utmostImportanceQueue: OperationQueue, timeInterval: TimeInterval) {
        self.backgroundQueue = backgroundQueue
        self.syncQueue = syncQueue
        self.utilityQueue = utilityQueue
        self.utmostImportanceQueue = utmostImportanceQueue
        self.timeInterval = timeInterval
        if let operations = operations {
            logInit(operations)
            self.syncQueue.addOperations(operations, waitUntilFinished: false)
        }
    }
    
    private func logInit(_ operations: [Operation]) {
        var messages: [String] = []
        messages.append("Initializing with types:")
        operations.forEach { messages.append("\t \($0)") }
        print(messages.joined(separator: "\n"))
    }
    
    deinit {
        print(#function)
    }
    
    public func makeTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval,
                                    target: self,
                                    selector: #selector(objc_sync),
                                    userInfo: nil,
                                    repeats: true)
    }
    
    @objc private func objc_sync(sender: Timer?) {
        guard self.timer === sender else { return }
        sync()
    }
    
    private func sync() {
        var message = ["Syncing operations of type:"]
        operationTypes.forEach {
            message.append("\t \($0)")
            syncQueue.addOperation($0.init())
        }
        print(message.joined(separator: "\n"))
    }
    
    public func restartSync() {
        print("Restarting Sync")
        self.timer?.invalidate()
        self.sync()
        self.timer = makeTimer()
    }
    
    public func add(recurringOperationType type: Operation.Type) {
        self.timer?.invalidate()
        self.operationTypes.append(type)
        self.timer = makeTimer()
    }
    
    public func addDistinct(recurringOperationType type: Operation.Type) {
        guard !self.operationTypes.contains(where: { $0 == type }) else { return }
        self.timer?.invalidate()
        self.operationTypes.append(type)
        self.timer = self.makeTimer()
    }
    
    public func add(operation: Operation, category: Category) {
        switch category {
        case .background:
            backgroundQueue.addOperation(operation)
        case .sync:
            syncQueue.addOperation(operation)
        case .utility:
            utilityQueue.addOperation(operation)
        case .utmostImportance:
            pause()
            backgroundQueue.waitUntilAllOperationsAreFinished()
            syncQueue.waitUntilAllOperationsAreFinished()
            utmostImportanceQueue.waitUntilAllOperationsAreFinished()
            utilityQueue.waitUntilAllOperationsAreFinished()
            utmostImportanceQueue.addOperation(operation)
            utmostImportanceQueue.isSuspended = false
            utmostImportanceQueue.waitUntilAllOperationsAreFinished()
            resume()
        }
    }
    
    public func cancelAllOperationsAndReset() {
        self.pause()
        syncQueue.waitUntilAllOperationsAreFinished()
        utilityQueue.waitUntilAllOperationsAreFinished()
        syncQueue.cancelAllOperations()
        utilityQueue.cancelAllOperations()
    }
    
    public func pause() {
        print("Pausing All Queues")
        self.timer?.invalidate()
        let isSuspended = true
        backgroundQueue.isSuspended = isSuspended
        syncQueue.isSuspended = isSuspended
        utmostImportanceQueue.isSuspended = isSuspended
        utilityQueue.isSuspended = isSuspended
    }
    
    public func resume() {
        print("Resuming All Queues")
        self.timer = makeTimer()
        let isSuspended = false
        backgroundQueue.isSuspended = isSuspended
        syncQueue.isSuspended = isSuspended
        utmostImportanceQueue.isSuspended = isSuspended
        utilityQueue.isSuspended = isSuspended
    }
    
    public func start(withRecurringOperationTypes operationTypes: [Operation.Type]) {
        logStart(operationTypes)
        self.timer?.invalidate()
        self.operationTypes = operationTypes
        self.timer = makeTimer()
    }
    
    private func logStart(_ operationTypes: [Operation.Type]) {
        var messages: [String] = []
        messages.append("Starting with recurring types:")
        operationTypes.forEach { messages.append("\t \($0.self)") }
        print(messages.joined(separator: "\n"))
    }
    
}


public func dispatch(_ interval: DispatchTimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: execute)
}

public func makeBackgroundQueue(_ name: String) -> OperationQueue {
    let queue = OperationQueue()
    queue.name = "com.trov.Tests.Background \(name)"
    queue.qualityOfService = .background
    return queue
}

public func makeSyncQueue(_ name: String) -> OperationQueue {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.name = "com.trov.Tests.Sync \(name)"
    queue.qualityOfService = .userInitiated
    return queue
}

public func makeUtilityQueue(_ name: String) -> OperationQueue {
    let queue = OperationQueue()
    queue.name = "com.trov.Tests.Utility \(name)"
    queue.qualityOfService = .utility
    return queue
}

public func makeUtmostImportanceQueue(_ name: String) -> OperationQueue {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.name = "com.trov.Tests.UtmostImportance \(name)"
    queue.qualityOfService = .userInteractive
    return queue
}
