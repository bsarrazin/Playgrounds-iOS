import Combine
import Foundation

// The `multicast` operator allows you to return a publisher of your choice.
// Its unique characteristic it that it returns a `ConnectablePublisher`.
// It will not start the stream until `connet()` is called.

let subject: PassthroughSubject<Data, URLError> = .init()
let multicasted = URLSession.shared
    .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com/")!)
    .map(\.data)
    .print("multicasted")
    .multicast(subject: subject)

let sub1 = multicasted
    .sink(
        receiveCompletion: { _ in },
        receiveValue: { print("1) received value:", $0) }
    )

let sub2 = multicasted
    .sink(
        receiveCompletion: { _ in },
        receiveValue: { print("2) received value:", $0) }
    )

// If a reference to the `connect()` cancellable isn't kept around
// the `multicasted` publisher will cancel after the first execution
let sub3 = multicasted.connect()

// subject.send(Data())
