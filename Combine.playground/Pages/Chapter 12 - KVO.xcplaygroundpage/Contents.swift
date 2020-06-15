import Combine
import Foundation

let queue = OperationQueue()
let subscription = queue
    .publisher(for: \.operationCount)
    .sink { print("Outstanding operations in queue:", $0) }

queue.addOperation { print("foo bar") }
