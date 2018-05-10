import Foundation

public protocol Cloak {
    associatedtype RawValue
    
    var rawValue: RawValue { get }
    
    init(rawValue: RawValue)
}
