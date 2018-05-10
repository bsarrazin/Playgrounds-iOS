import Foundation

public struct Market {
    public let code: String
}

public extension Market {
    public static let au = Market(code: "AU")
    public static let gb = Market(code: "GB")
    public static let us = Market(code: "US")
}

extension Market: Hashable {
    public var hashValue: Int { return code.hashValue }
    
    public static func ==(lhs: Market, rhs: Market) -> Bool {
        return lhs.code == rhs.code
    }
}

//struct MarketBehaviorKey {
//    let key: String
//}

public struct MarketBehavior<T> {
    private let key: String
    private let `default`: T
    private let value: ((Market) -> T)?
    public init(key: String, `default`: T, value: ((Market) -> T)? = nil) {
        self.key = key
        self.`default` = `default`
        self.value = value
    }
    public func value(for market: Market) -> T {
        guard let value = self.value else { return `default` }
        return value(market)
    }
}

extension MarketBehavior {
    static var isSicEnabled: MarketBehavior<Bool> {
        return .init(
            key: "isSicEnabled",
            default: true,
            value: { market in
                switch market {
                case .au: return true
                case .gb: return true
                case .us: return false
                default: return false
                }
            }
        )
    }
    static var walkthroughInitialPage: MarketBehavior<Int> {
        return .init(
            key: "walkthroughInitialPage",
            default: 0
        )
    }
}

class MarketBehaviorProvider {
    private let market: Market
    init(market: Market) { self.market = market }
    func value<T>(for behavior: MarketBehavior<T>) -> T {
        return behavior.value(for: market)
    }
}

let provider = MarketBehaviorProvider(market: .au)
let isSicEnabled = provider.value(for: .isSicEnabled)
let walkthroughInitialPage = provider.value(for: .walkthroughInitialPage)
