import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let api = API()
var subscriptions: Set<AnyCancellable> = []

api.story(id: 1000)
    .sink(
        receiveCompletion: { print("Received completion:", $0) },
        receiveValue: { story in print("Received value:", story) }
    )
    .store(in: &subscriptions)

api.mergedStories(ids: [1000, 1001, 1002])
    .sink(
        receiveCompletion: { print("Received completion:", $0) },
        receiveValue: { story in print("Received value:", story) }
    )
    .store(in: &subscriptions)

api.stories()
    .sink(
        receiveCompletion: { print("Received completion:", $0) },
        receiveValue: { story in print("Received value:", story) }
    )
    .store(in: &subscriptions)
