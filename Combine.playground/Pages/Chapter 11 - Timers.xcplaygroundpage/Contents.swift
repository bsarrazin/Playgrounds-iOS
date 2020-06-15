import Combine
import Foundation

// MARK: - RunLoop
// let loop: RunLoop = .main
// let subscription = loop.schedule(
//     after: loop.now,
//     interval: .seconds(1),
//     tolerance: .milliseconds(100)
// ) {
//     print("Timer fired!")
// }

// MARK: - Timer
// let publisher = Timer
//     .publish(every: 1.0, on: .main, in: .common)
//     .autoconnect()
//     .scan(0) { counter, _ in counter + 1 }
//     .sink { counter in print("Counter is:", counter) }

// MARK: - DispatchQueu
let queue: DispatchQueue = .main
let source: PassthroughSubject<Int, Never> = .init()
var counter = 0

let cancellable = queue.schedule(after: queue.now, interval: .seconds(1)) {
    source.send(counter)
    counter += 1
}

let subscription = source.sink {
    print("Timer emitted:", $0)
}
