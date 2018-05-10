import Dispatch
import Foundation

public func xexample(_ label: String, queue: DispatchQueue = DispatchQueue.main, block: @escaping (String) -> Void) {}
public func example(_ label: String, queue: DispatchQueue = DispatchQueue.main, block: @escaping (String) -> Void) {
    queue.async {
        print("---------- \(label) ----------")
        block(label)
        print("\n\n")
    }
}

public func random(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
}
