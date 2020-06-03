import Combine
import Foundation

var subscriptions: Set<AnyCancellable> = []

xexample(of: "Collect") {
    ["A", "B", "C", "D", "E"]
        .publisher
        .collect(2)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)
}

xexample(of: "Mapping") {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut

    [123, 4, 56]
        .publisher
        .compactMap { formatter.string(from: $0) }
        .sink { print($0) }
        .store(in: &subscriptions)
}

xexample(of: "Mapping Key Paths") {
    let subject: PassthroughSubject<Coordinate, Never> = .init()

    subject
        .map(\.x, \.y)
        .sink { x, y in print("The coordinate at \(x), \(y) is in quandrant", quadrantOf(x: x, y: y)) }
        .store(in: &subscriptions)

    subject.send(Coordinate(x: 10, y: -8))
    subject.send(Coordinate(x: -10, y: -8))
    subject.send(Coordinate(x: 0, y: 0))
}

xexample(of: "tryMap") {
    Just("Directory name that does not exist")
        .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)
}

xexample(of: "Flat Mapping") {
    let foo = Chatter(name: "Foo", message: "Hey, I'm Foo!")
    let bar = Chatter(name: "Bar", message: "Hi, I'm Bar!")

    let chat: CurrentValueSubject<Chatter, Never> = .init(foo)

    chat
        .flatMap(maxPublishers: .max(2)) { $0.message} // private convo between the first 2
        .sink { print($0) }
        .store(in: &subscriptions)

    foo.message.value = "Foo: How's it going?"

    chat.value = bar

    bar.message.value = "Bar: Pretty good, how about you?"

    let baz = Chatter(name: "Baz", message: "Hello! I'm Baz!")

    chat.value = baz

    foo.message.value = "Hey Baz! Welcome to the chat!"
    bar.message.value = "Welcome, Baz!"

    baz.message.value = "Awww thanks guys!"

    chat.value = foo // Added to chat a second time, messages will be duplicated

    baz.message.value = "So it's it cold here or what?"
    foo.message.value = "brrrrr"
}

xexample(of: "replaceNil(with:)") {
    ["A", nil, "C"]
        .publisher
        .replaceNil(with: "B")
        .compactMap { $0 }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "replaceEmpty(with:)") {
    let empty: Empty<Int, Never> = .init()

    empty
        .replaceEmpty(with: 1)
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "scan(_:_:)") {
    var delta: Int { .random(in: -10...10) }
    let publisher = (0..<22)
        .map { _ in delta }
        .publisher

    publisher
        .scan(50) { latest, current in
            max(0, latest + current)
        }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

example(of: "Challenge") {
    let contacts = [
        "603-555-1234": "Florent",
        "408-555-4321": "Marin",
        "217-555-1212": "Scott",
        "212-555-3434": "Shai"
    ]

    func convert(phoneNumber: String) -> Int? {
        if let number = Int(phoneNumber),
            number < 10 {
            return number
        }

        let keyMap: [String: Int] = [
            "abc": 2, "def": 3, "ghi": 4,
            "jkl": 5, "mno": 6, "pqrs": 7,
            "tuv": 8, "wxyz": 9
        ]

        let converted = keyMap
            .filter { $0.key.contains(phoneNumber.lowercased()) }
            .map { $0.value }
            .first

        return converted
    }

    func format(digits: [Int]) -> String {
        var phone = digits.map(String.init)
            .joined()

        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 3)
        )

        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 7)
        )

        return phone
    }

    func dial(phoneNumber: String) -> String {
        guard let contact = contacts[phoneNumber] else {
            return "Contact not found for \(phoneNumber)"
        }

        return "Dialing \(contact) (\(phoneNumber))..."
    }

    let input = PassthroughSubject<String, Never>()

    input
        .map(convert)
        .replaceNil(with: 0)
        .collect(10)
        .map(format)
        .map(dial)
        .sink { print($0) }
        .store(in: &subscriptions)

    "0!1234567".forEach {
        input.send(String($0))
    }

    "4085554321".forEach {
        input.send(String($0))
    }

    "A1BJKLDGEH".forEach {
        input.send("\($0)")
    }
}
