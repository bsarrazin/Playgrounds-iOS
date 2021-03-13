import Foundation

public struct Identifier<T>: Cloak, Hashable, Codable {
    public let rawValue: String
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}
