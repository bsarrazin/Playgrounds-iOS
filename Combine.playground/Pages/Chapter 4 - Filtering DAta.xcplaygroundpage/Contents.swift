import Combine
import Foundation

var subscriptions: Set<AnyCancellable> = []

xexample(of: "Filter") {
    let numbers = (1...10).publisher

    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "remove duplicates") {
    let words = "hey hey there! want to listen to mister mister ?"
        .components(separatedBy: " ")
        .publisher

    words
        .removeDuplicates()
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "compacting") {
    let strings = ["a", "1.24", "3", "def", "45", "0.23"].publisher

    strings
        .compactMap { Float($0) }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "ignoring") {
    let numbers = (1...10_000).publisher

    numbers
        .ignoreOutput()
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)
}

xexample(of: "first(where:)") {
    let numbers = (1...9).publisher

    numbers
        .print("numbers")
        .first { $0 % 2 == 0 }
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)
}

xexample(of: "last(where:)") {
    let numbers = (1...9).publisher

    numbers
        .print("numbers")
        .last { $0 % 2 == 0 }
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)
}

xexample(of: "last(where:)") {
    let subject: PassthroughSubject<Int, Never> = .init()

    subject
        .last { $0 % 2 == 0 }
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)

    subject.send(1)
    subject.send(2)
    subject.send(3)
    subject.send(4)
    subject.send(5)

    // why is the stream not returning anything?
}

xexample(of: "dropFirst") {
    (1...10)
        .publisher
        .dropFirst(8)
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "drop(while:)") {
    (1...10)
        .publisher
        .drop { print("drop:", $0); return $0 % 5 != 0 }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "drop(untilOutputFrom:)") {
    let isReady: PassthroughSubject<Void, Never> = .init()
    let taps: PassthroughSubject<Int, Never> = .init()

    taps
        .drop(untilOutputFrom: isReady)
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)

    (1...5).forEach {
        taps.send($0)

        if $0 == 3 {
            isReady.send()
        }
    }
}

xexample(of: "prefix") {
    (1...10)
        .publisher
        .prefix(2)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)
}

xexample(of: "prefix(while:)") {
    (1...10)
        .publisher
        .prefix { print("prefix:", $0); return $0 < 3 }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "prefix(untilOutputFrom:)") {
    let isReady: PassthroughSubject<Void, Never> = .init()
    let taps: PassthroughSubject<Int, Never> = .init()

    taps
        .prefix(untilOutputFrom: isReady)
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)

    (1...5).forEach {
        taps.send($0)

        if $0 == 3 {
            isReady.send()
        }
    }
}

example(of: "Challenge") {
    // 1. numbers from 1 to 100
    // 2. skip the first 50
    // 3. take only the next 20
    // 4. take only the even numbers
    (1...100)
        .publisher
        .dropFirst(50)
        .prefix(20)
        .filter { $0.isMultiple(of: 2) }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}
