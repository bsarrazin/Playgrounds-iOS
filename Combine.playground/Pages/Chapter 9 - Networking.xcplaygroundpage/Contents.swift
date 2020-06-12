import Combine
import Foundation

let timestamp = Date().timeIntervalSince1970.description
let hash = (timestamp + Marvel.Key.private + Marvel.Key.public).md5()
let url = URL(string: "https://gateway.marvel.com:443/v1/public/characters?apikey=\(Marvel.Key.public)&hash=\(hash)&ts=\(timestamp)")!

let pub = URLSession.shared
    .dataTaskPublisher(for: url)
    .map(\.data).decode(type: Marvel.Response<Marvel.Character>.self, decoder: JSONDecoder())
    .handleEvents(receiveOutput: { _ in
        print("performed network call")
    })
    // This operator shares the same subscriber?
    // I need to understand more what this does. Right now, if we don't use .share(), the network call will happen twice.
    // .share()

    // This operator prevents subscriptions from firing up the publisher.
    // It allows for all subscribers to subscribe and then a subsequent call to
    // .connect() is required to fire up the publisher, effectively preventing the network call to happen twice.
    .multicast { PassthroughSubject<Marvel.Response<Marvel.Character>, Error>() }

let sub1 = pub
    .sink(
        receiveCompletion: { completion in
            print("received completion: \(completion)")
        },
        receiveValue: { marvel in
            print("received marvel response: \(marvel.data.results[0].name)")
        }
    )

let sub2 = pub
    .sink(
        receiveCompletion: { completion in
            print("received completion: \(completion)")
        },
        receiveValue: { marvel in
            print("received marvel response: \(marvel.data.results[0].name)")
        }
    )

let sub3 = pub.connect() // have to connect() to start the network call when using multicast
