import Foundation
import UIKit

public protocol DynamicProperties: class {
    subscript<T>(dynamic key: String) -> T? { get set }
}

private extension String {
    var unsafePointer: UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: hashValue)!
    }
}
public extension DynamicProperties {
    public subscript<T>(dynamic key: String) -> T? {
        get { return objc_getAssociatedObject(self, key.unsafePointer) as? T }
        set { objc_setAssociatedObject(self, key.unsafePointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension NSObject: DynamicProperties { }


let view = UIView()
view[dynamic: "hello"] = 4
let v: Int? = view[dynamic: "hello"]
print(v)
