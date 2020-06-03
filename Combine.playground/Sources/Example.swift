import Foundation

public func xexample(of label: String, closure: () -> Void) { }
public func example(of label: String, closure: () -> Void) {
    print("----- \(label) -----")
    closure()
    print("")
}
