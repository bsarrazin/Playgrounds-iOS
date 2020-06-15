import Combine
import Foundation

var subscriptions: Set<AnyCancellable> = []

xexample(of: "print") {
    (1...3).publisher
        .print("publisher")
        .sink { _ in }
        .store(in: &subscriptions)
}

xexample(of: "print(_:to:)") {
    class TimeLogger: TextOutputStream {
        private var previous = Date()
        private let formatter = NumberFormatter()

        init() {
            formatter.maximumFractionDigits = 5
            formatter.minimumFractionDigits = 5
        }

        func write(_ string: String) {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return  }

            let now = Date()
            let delta = now.timeIntervalSince(previous)
            let time = formatter.string(from: NSNumber(value: delta))!
            print("+\(time)s: \(trimmed)")
            previous = now
        }
    }

    (1...3)
        .publisher
        .print("publisher", to: TimeLogger())
        .sink { _ in }
        .store(in: &subscriptions)
}

xexample(of: "handleEvents") {
    (1...10)
        .publisher
        .handleEvents(
            receiveSubscription: { subscription in
                print("Received subscription:", subscription.combineIdentifier)
            },
            receiveOutput: { output in
                print("Received output:", output)
            },
            receiveCompletion: { completion in
                print("Received completion:", completion)
            },
            receiveCancel: {
                print("Received cancellation")
            },
            receiveRequest: { demand in
                print("Received request:", demand)
            }
        )
        .sink(
            receiveCompletion: { print("SINK Received Completion:", $0) },
            receiveValue: { print("SINK Received Value:", $0) }
        )
        .store(in: &subscriptions)
}

example(of: "breakpointOnError") {
    (1...25)
        .publisher
        .breakpoint(receiveOutput: { value in return value > 10 && value < 15 })
        .sink { print($0) }
        .store(in: &subscriptions)
}
