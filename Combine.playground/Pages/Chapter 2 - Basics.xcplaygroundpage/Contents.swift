import Combine
import Foundation

/*
 Under the covers...

 Publisher                                Subscriber
     |                                         |
     |
     | <--------- subscribes        ---------- 1
     |
                                               |
     2 ---------- give subscription ---------> |
                                               |
     |
     | <--------- requests values   ---------- 3
     |
                                               |
     4 ---------- sends values      ---------> |
                                               |
     |                                         |
                                               |
     5 ---------- sends completion  ---------> |
                                               |
     |                                         |
     V                                         V

 1. the subscriber subscribes to the publisher
 2. the publisher creates a subscription and gives it to the subscriber
 3. the subscriber requests values
 4. the publisher sends values
 5. the publisher sends a completion (or error)
 */

xexample(of: "Classic") {
    let center: NotificationCenter = .default
    let notification: Notification.Name = .init("MyNotification")

    let observer = center.addObserver(forName: notification, object: nil, queue: nil) { notification in
        print("Notification received:", notification.name)
    }

    center.post(name: notification, object: nil)
    center.removeObserver(observer)
}

xexample(of: "Publisher & Subscriber") {
    let center: NotificationCenter = .default
    let notification: Notification.Name = .init("MyNotification")
    let publisher = center.publisher(for: notification)

    let subscription = publisher.sink { notification in
        print("Notification received:", notification.name)
    }

    center.post(name: notification, object: nil)
    subscription.cancel()
}

xexample(of: "Just & sink(receiveCompletion:receiveValue)") {
    let just = Just("Hello, World!")
    _ = just.sink(
        receiveCompletion: { event in
            print("Event:", event)
        },
        receiveValue: { value in
            print("Value:", value)
        }
    )
    _ = just.sink(
        receiveCompletion: { event in
            print("Event2:", event)
        },
        receiveValue: { value in
            print("Value2:", value)
        }
    )
}

xexample(of: "assign(to:on:)") {
    final class Foo {
        var value: String = "" {
            didSet { print("Value:", value) }
        }
    }

    let foo = Foo()
    let publisher = ["Hello", "World!"].publisher

    _ = publisher.assign(
        to: \.value,
        on: foo
    )
}

xexample(of: "Custom Subscriber") {

    class IntSubscriber: Subscriber {
        typealias Input = Int
        typealias Failure = Never

        func receive(subscription: Subscription) {
            subscription.request(.max(3))
        }
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value:", input)
            return .none
        }
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion:", completion)
        }
    }

    let subscriber = IntSubscriber()
    let publisher = (1...3).publisher
    publisher.subscribe(subscriber)
}

var subscriptions: Set<AnyCancellable> = []

xexample(of: "Future") {
    let increment: (Int, TimeInterval) -> Future<Int, Never> = { int, delay in
        .init { promise in
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + delay) {
                    promise(.success(int + 1))
                }
        }
    }

    let future = increment(1, 3)
    future.sink(
        receiveCompletion: { event in
            print("Received event:", event)
        },
        receiveValue: { int in
            print("Received value:", int)
        }
    )
    .store(in: &subscriptions)
}

xexample(of: "PassthroughSubject") {
    enum Error: Swift.Error {
        case test
    }

    final class StringSubscriber: Subscriber {
        typealias Input = String
        typealias Failure = Error

        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }

        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value:", input)
            return input == "World" ? .max(1) : .none
        }

        func receive(completion: Subscribers.Completion<Error>) {
            print("Received completion:", completion)
        }
    }

    let subscriber = StringSubscriber()
    let subject = PassthroughSubject<String, Error>()
    subject.subscribe(subscriber)

    let subscription = subject.sink(
        receiveCompletion: { event in
            print("sink event:", event)
        },
        receiveValue: { value in
            print("sink value:", value)
        }
    )

    subject.send("Hello")
    subject.send("World")

    subscription.cancel()

    subject.send("Still there?")
    subject.send(completion: .failure(.test))
    subject.send(completion: .finished)
    subject.send("how about another one?")
}

xexample(of: "CurrentValueSubejct") {
    var subscriptions: Set<AnyCancellable> = []

    let subject: CurrentValueSubject<Int, Never> = .init(0)

    subject
        .print()
        .sink { print("int:", $0) }
        .store(in: &subscriptions)

    subject.send(1)
    subject.send(2)

    print("current value:", subject.value)

    subject.value = 3

    print("current value:", subject.value)

    subject
        .print("2nd")
        .sink { print("2nd int:", $0) }
        .store(in: &subscriptions)

    subject.send(completion: .finished)
}

example(of: "Dynamically adjusting demand") {
    final class IntSubscriber: Subscriber {
        typealias Input = Int
        typealias Failure = Never

        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }
        func receive(_ input: Int) -> Subscribers.Demand {
            print("Received value:", input)

            switch input {
            case 1: return .max(2)
            case 3: return .max(1)
            default: return .none
            }
        }
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion:", completion)
        }
    }

    let subscriber = IntSubscriber()
    let subject: PassthroughSubject<Int, Never> = .init()
    subject.subscribe(subscriber)

    subject.send(1)
    subject.send(2)
    subject.send(3)
    subject.send(4)
    subject.send(5)
    subject.send(6)
}

xexample(of: "Type Erasure") {
    let subject: PassthroughSubject<Int, Never> = .init()
    let publisher: AnyPublisher<Int, Never> = subject.eraseToAnyPublisher()

    publisher
        .sink { print("int:", $0) }
        .store(in: &subscriptions)

    subject.send(0)
}

xexample(of: "Challenge") {
    let dealtHand = PassthroughSubject<Hand, HandError>()

    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining = 52
        var hand = Hand()

        for _ in 0 ..< cardCount {
            let randomIndex = Int.random(in: 0 ..< cardsRemaining)
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }

        // Add code to update dealtHand here
        if hand.points > 21 {
            dealtHand.send(completion: .failure(.busted))
        } else {
            dealtHand.send(hand)
        }
    }

    // Add subscription to dealtHand here
    dealtHand
        .sink(
            receiveCompletion: { completion in
                print("Received completion:", completion)
            },
            receiveValue: { hand in
                print("hand:", hand)
            }
        )
        .store(in: &subscriptions)

    deal(3)
}

// Questions

