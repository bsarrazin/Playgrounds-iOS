import Foundation
import UIKit

class ColorAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] { [UIColor.self] }

    static func register() {
        let name = String(describing: Self.self)
        let transformer = ColorAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: .init(name))
    }
}
