import Foundation

public struct Setting<T: Codable>: Codable {
    public let key: String
    public let `default`: T
    
    public init(key: String, `default`: T) {
        self.key = key
        self.`default` = `default`
    }
}

public protocol SettingStore {
    @discardableResult
    func remove<T>(_ setting: Setting<T>) -> T
    func removeAll()
    func update<T>(_ setting: Setting<T>, to value: T)
}
