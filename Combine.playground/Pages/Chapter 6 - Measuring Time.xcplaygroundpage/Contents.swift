import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

let subjectTimeline = TimelineView(title: "Subject Timeline")
let measuredTimeline = TimelineView(title: "Measured Timeline")

let view = VStack(spacing: 100) {
    subjectTimeline
    measuredTimeline
}
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

let subject: PassthroughSubject<String, Never> = .init()
let measureSubject = subject.measureInterval(using: RunLoop.main)

subject.displayEvents(in: subjectTimeline)
measureSubject.displayEvents(in: measuredTimeline)

let sub1 = subject.sink {
    print("\(deltaTime)s: Subject emitted: \($0)")
}
let sub2 = measureSubject.sink {
    print("\(deltaTime)s: Mesured emitted: \(Double($0.magnitude) / 1_000_000_000.0)")
}

subject.feed(with: typingHelloWorld)
