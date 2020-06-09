import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

let timeline = TimelineView(title: "")
let view = VStack(spacing: 100) {
    Button(action: { subject.send() }) {
        Text("Press me within 5 seconds")
    }
    timeline
}
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

enum TimeoutError: Error {
    case timedOut
}
let subject: PassthroughSubject<Void, TimeoutError> = .init()
let timedOutSbuject = subject.timeout(.seconds(5), scheduler: DispatchQueue.main, customError: { .timedOut })

timedOutSbuject.displayEvents(in: timeline)
