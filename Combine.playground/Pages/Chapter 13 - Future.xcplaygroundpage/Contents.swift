import Combine
import Foundation

// The `Future` is a class.
// Immediately starts processing the closure and stores the result for later.
// All current and _new_ subscribers are going to receive the result

let future: Future<Int, URLError> = .init { promise in
    print("computing...")
    promise(.success(0))
    // promise(.failure(.init(.badServerResponse)))
}

// future.sink(
//     receiveCompletion: { print("received completion:", $0) },
//     receiveValue: { print("received value:", $0) }
// )
