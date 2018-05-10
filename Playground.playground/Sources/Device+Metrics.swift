import UIKit

public extension UIDevice {
    public enum Metrics {
        case iPhone4
        case iPhoneSE
        case iPhone8
        case iPhoneX
        case iPhone8Plus
        case iPadPro97
        case iPadPro105
        case iPadPro129
        
        public var size: CGSize {
            switch self {
            case .iPhone4: return CGSize(width: 320, height: 480)
            case .iPhoneSE: return CGSize(width: 320, height: 568)
            case .iPhone8: return CGSize(width: 375, height: 667)
            case .iPhoneX: return CGSize(width: 375, height: 812)
            case .iPhone8Plus: return CGSize(width: 414, height: 736)
            case .iPadPro97: return CGSize(width: 768, height: 1024)
            case .iPadPro105: return CGSize(width: 1112, height: 834)
            case .iPadPro129: return CGSize(width: 1024, height: 1366)
            }
        }
    }
}
