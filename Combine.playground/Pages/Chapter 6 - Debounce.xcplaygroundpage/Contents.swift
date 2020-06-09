import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

let subjectTimeline = TimelineView(title: "Emitted values")
let debouncedTimeline = TimelineView(title: "Debounced values")

let view = VStack(spacing: 100) {
    subjectTimeline
    debouncedTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

let subject: PassthroughSubject<String, Never> = .init()
let debounced = subject
    .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
    .share()

subject.displayEvents(in: subjectTimeline)
debounced.displayEvents(in: debouncedTimeline)

let subscription1 = subject.sink {
    print("subject value: \($0)")
}
let subscription2 = debounced.sink {
    print("debounced value: \($0)")
}

subject.feed(with: typingHelloWorld)
