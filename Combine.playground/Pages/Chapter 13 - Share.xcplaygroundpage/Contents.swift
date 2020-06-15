import Combine
import Foundation

// The `share()` operator returns the publish by `reference` instead of by `value`.
// This prevents the subscriptions to fire the publisher more than once and "share" the output.
// New subscriptions will only get the values emitted after they've subscribed OR
// the completion event if the stream has already completed.

let shared = URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com/")!)
    .map(\.data)
    .print("shared")
    .share()

print("Subscribing First")

let sub1 = shared.sink(
    receiveCompletion: {
        print("ONE Received completion:", $0)
    },
    receiveValue: {
        print("ONE Received value:", $0)
    }
)

print("Subscribing Second")

let sub2 = shared.sink(
    receiveCompletion: {
        print("TWO Received completion:", $0)
    },
    receiveValue: {
        print("TWO Received value:", $0)
    }
)

var sub3: AnyCancellable?
DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
    sub3 = shared.sink(
        receiveCompletion: {
            print("THREE Received completion:", $0)
        },
        receiveValue: {
            print("THREE Received value:", $0)
        }
    )
}
