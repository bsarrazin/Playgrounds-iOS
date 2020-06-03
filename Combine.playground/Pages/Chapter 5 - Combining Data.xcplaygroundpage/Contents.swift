import Combine
import Foundation
import UIKit

var subscriptions: Set<AnyCancellable> = []

xexample(of: "prepend(Output...)") {
    [3, 4]
        .publisher
        .prepend(1, 2)
        .prepend(-1, 0)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)
}

xexample(of: "prepend(Publisher)") {
    let pub1 = [3, 4].publisher
    let pub2 = [1, 2].publisher

    pub1
        .prepend(pub2)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)

    // 2nd Example
    let subject: PassthroughSubject<Int, Never> = .init()
    [3, 4]
        .publisher
        .prepend(subject)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)

    subject.send(1)
    subject.send(2)

    // why is 3 and 3 not emitted?)
}

xexample(of: "switchToLatest") {
    let pub1: PassthroughSubject<Int, Never> = .init()
    let pub2: PassthroughSubject<Int, Never> = .init()
    let pub3: PassthroughSubject<Int, Never> = .init()

    let publishers: PassthroughSubject<PassthroughSubject<Int, Never>, Never> = .init()

    publishers
        .switchToLatest()
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)

    publishers.send(pub1)
    pub1.send(1)
    pub1.send(2)

    publishers.send(pub2)
    pub2.send(3)
    pub2.send(4)
    pub2.send(5)

    publishers.send(pub3)
    pub3.send(6)
    pub3.send(7)
    pub3.send(8)
    pub3.send(9)

    pub3.send(completion: .finished)
    publishers.send(completion: .finished)
}

xexample(of: "switchToLatest for network") {
    let url = URL(string: "https://source.unsplash.com/random")!

    func getImage() -> AnyPublisher<UIImage?, Never> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .print("image")
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }

    let taps: PassthroughSubject<Void, Never> = .init()
    taps
        .map { _ in getImage() }
        .switchToLatest()
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0 as Any) }
        )
        .store(in: &subscriptions)

    taps.send()

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { taps.send() }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) { taps.send() }
}

xexample(of: "merge(with:)") {
    let pub1: PassthroughSubject<Int, Never> = .init()
    let pub2: PassthroughSubject<Int, Never> = .init()

    pub1
        .merge(with: pub2)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)

    pub1.send(1)
    pub1.send(2)

    pub2.send(3)

    pub1.send(4)

    pub2.send(5)
}

xexample(of: "combineLatest") {
    let pub1: PassthroughSubject<Int, Never> = .init()
    let pub2: PassthroughSubject<String, Never> = .init()

    pub1
        .combineLatest(pub2)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)

    pub1.send(1)
    pub1.send(2)

    pub2.send("one")
    pub2.send("two")

    pub1.send(3)
    pub2.send("three")
}

xexample(of: "zip") {
    let pub1: PassthroughSubject<Int, Never> = .init()
    let pub2: PassthroughSubject<String, Never> = .init()

    pub1
        .zip(pub2)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
    )
        .store(in: &subscriptions)

    pub1.send(1)
    pub1.send(2)

    pub2.send("one")
    pub2.send("two")

    pub1.send(3)
    pub2.send("three")
}
