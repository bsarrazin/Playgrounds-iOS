import Combine
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let api = API()
var subscriptions: Set<AnyCancellable> = []

api.stories()
    .sink(
        receiveCompletion: { print("Received completion:", $0) },
        receiveValue: { story in print("Received value:", story) }
    )
    .store(in: &subscriptions)
