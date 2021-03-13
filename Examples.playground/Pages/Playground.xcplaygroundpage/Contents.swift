import Combine
import UIKit

struct Foo {
    var bar: String { print(#function); return #function }
    var qux: String {
        didSet { print(#function) }
    }
}

var foo = Foo(qux: "qux")
foo.bar
foo.qux = "baz"



class DynamicTimer {

    private let nextFire: () -> TimeInterval
    private var timer: Timer

    init(nextFire: @escaping () -> TimeInterval) {
        self.nextFire = nextFire
        self.timer = Self.makeTimer(nextFire())
    }

    private static func makeTimer(_ timeInterval: TimeInterval) -> Timer {
        return .scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(DynamicTimer.timerDidFire(_:)),
            userInfo: nil,
            repeats: false
        )
    }

    @objc func timerDidFire(_: Timer) {
        print("timer", timer)
        timer = Self.makeTimer(nextFire())
    }

}

let timer = DynamicTimer { 2 }
