import Foundation

extension API {
    public enum Error: LocalizedError {
        case addressUnreachable(URL)
        case invalidResponse

        public var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server responded with garbage."
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            }
        }
    }
}
