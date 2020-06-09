import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

extension Double {
    static let valuesPerSecond: Double = 1.0
    static let collectTimeStride: Double = 4
}
extension Int {
    static let collectMaxCount: Int = 2
}

let sourceTimeline = TimelineView(title: "Emitted values (\(Double.valuesPerSecond) per sec.):")
let collectedTimeline = TimelineView(title: "Collected values (every \(Double.collectTimeStride)s:")
let collectedTimeline2 = TimelineView(title: "Collected values (every \(Double.collectTimeStride)s or max of \(Int.collectMaxCount):")

PlaygroundPage.current.liveView = UIHostingController(rootView: VStack(spacing: 50) {
    sourceTimeline
    collectedTimeline
    collectedTimeline2
})

let sourcePublisher: PassthroughSubject<Date, Never> = .init()
let collectedPublisher = sourcePublisher
    .collect(.byTime(DispatchQueue.main, .seconds(.collectTimeStride)))
    .flatMap { dates in dates.publisher }
let collectedPublisher2 = sourcePublisher
    .collect(.byTimeOrCount(DispatchQueue.main, .seconds(.collectTimeStride), .collectMaxCount))
    .flatMap { dates in dates.publisher}

let subscription = Timer
    .publish(every: 1.0 / .valuesPerSecond, on: .main, in: .common)
    .autoconnect()
    .subscribe(sourcePublisher)

sourcePublisher.displayEvents(in: sourceTimeline)
collectedPublisher.displayEvents(in: collectedTimeline)
collectedPublisher2.displayEvents(in: collectedTimeline2)
