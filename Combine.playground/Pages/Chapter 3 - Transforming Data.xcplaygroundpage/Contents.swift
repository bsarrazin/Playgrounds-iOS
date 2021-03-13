import Combine
import Foundation

var subscriptions: Set<AnyCancellable> = []

xexample(of: "Collect") {
    ["A", "B", "C", "D", "E"]
        .publisher
        .collect(3)
        .sink(
            receiveCompletion: { print("Received completion:", $0) },
            receiveValue: { print("Received value:", $0) }
        )
        .store(in: &subscriptions)

    // Examples:
    // - batching 100 logs, then send it remotely
}

xexample(of: "Mapping") {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut

    ["123", "42", "99"]
        .publisher
        .map { Int($0) }
        .filter { $0 != nil }
        .replaceNil(with: -1)
        .sink { print($0) }
        .store(in: &subscriptions)

    // Examples:
    // - messages into table cell view models
}

xexample(of: "Mapping Key Paths") {
    let subject: PassthroughSubject<Coordinate, Never> = .init()

    subject
        .map(\.x, \.y) // Up to 3
        .sink { x, y in print("The coordinate at \(x), \(y) is in quandrant", quadrantOf(x: x, y: y)) }
        .store(in: &subscriptions)

    subject.send(Coordinate(x: 10, y: -8))
    subject.send(Coordinate(x: -10, y: -8))
    subject.send(Coordinate(x: 0, y: 0))

    // Examples:
    // - view model property to assign to label.text
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
    func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
        return Just(
            codes.compactMap { code in
                guard (32...255).contains(code) else { return nil }
                return String(UnicodeScalar(code) ?? " ")
            }
            .joined()
        ).eraseToAnyPublisher()
    }

    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33].publisher
        .collect()
        .flatMap(decode)
        .sink { print($0) }
        .store(in: &subscriptions)
}

xexample(of: "Slightly More Complex Flat Mapping") {
    let foo = Chatter(name: "Foo", message: "Foo: Hey, I'm Foo!")
    let bar = Chatter(name: "Bar", message: "Bar: Hi, I'm Bar!")

    let chat: CurrentValueSubject<Chatter, Never> = .init(foo)

    chat
        .flatMap(maxPublishers: .max(2)) { $0.message } // ✌️ .max(2) makes this a chat with max of 2 people, `Foo` was already added in the init
        .sink { print($0) }
        .store(in: &subscriptions)

    foo.message.value = "Foo: How's it going?"

    chat.value = bar // ✅ adding `Bar` to the chat

    bar.message.value = "Bar: Pretty good, how about you?"

    let baz = Chatter(name: "Baz", message: "Baz: Hello! I'm Baz!")
    chat.value = baz // ❌ unable to add `Baz` to the chat

    foo.message.value = "Foo: Hey Baz! Welcome to the chat!"

    bar.message.value = "Bar: Welcome, Baz!"

    baz.message.value = "Baz: Awww thanks guys!"
    baz.message.value = "Baz: So is it cold here or what?"

    foo.message.value = "Foo: brrrrr"
}

example(of: "replaceNil(with:)") {
    [nil, nil, nil]
        .publisher
        .replaceEmpty(with: -1)
//        .replaceNil(with: "B")
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

example(of: "replaceEmpty(with:)") {
    let empty: Empty<Int, Never> = .init()

    empty
        .replaceEmpty(with: 1)
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "replaceEmpty(with:)") {
    let subject = PassthroughSubject<Int, Never>()

    subject
        .replaceEmpty(with: 42)
        .sink { print("Received value: \($0)") }
        .store(in: &subscriptions)

    subject.send(completion: .finished)
}

xexample(of: "scan(_:_:)") {
    var delta: Int { .random(in: -10...10) }
    let days = (0..<10)
        .map { _ in delta }
        .publisher

    days
        .scan(100) { latest, current in
            max(0, latest + current)
        }
        .sink { print("Received value:", $0) }
        .store(in: &subscriptions)
}

xexample(of: "Challenge") {
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
