import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

extension Double {
    static let valuesPerSecond: Double = 2.0
    static let delayInSeconds: Double = 1.5
}

let sourceTimeline = TimelineView(title: "Emitted values (\(Double.valuesPerSecond) per sec.):")
let delayedTimeline = TimelineView(title: "Delayed values (with a \(Double.delayInSeconds)s delay:")

PlaygroundPage.current.liveView = UIHostingController(rootView: VStack(spacing: 50) {
    sourceTimeline
    delayedTimeline
})

let sourcePublisher: PassthroughSubject<Date, Never> = .init()
let delayedPublisher = sourcePublisher.delay(for: .seconds(.delayInSeconds), scheduler: DispatchQueue.main)

let subscription = Timer
    .publish(every: 1.0 / .valuesPerSecond, on: .main, in: .common)
    .autoconnect()
    .subscribe(sourcePublisher)

sourcePublisher.displayEvents(in: sourceTimeline)
delayedPublisher.displayEvents(in: delayedTimeline)

