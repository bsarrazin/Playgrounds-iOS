import CoreData
import Foundation
import UIKit

private extension String {
    static let errorDomain = "CoreData Migration"
}

class MigrationPolicy3To4AttachmentToImageAttachment: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource source: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let desc = NSEntityDescription.entity(forEntityName: "ImageAttachment", in: manager.destinationContext)
        let attachment = ImageAttachment(entity: desc!, insertInto: manager.destinationContext)

        func traversePropertyMappings(_ block: (NSPropertyMapping, String) -> Void) throws {
            guard let mappings = mapping.attributeMappings else {
                throw NSError( domain: .errorDomain, code: 0, userInfo: [
                    NSLocalizedFailureReasonErrorKey: "No attribute mappings found!"
                ])
            }

            for mapping in mappings {
                if let name = mapping.name {
                    block(mapping, name)
                } else {
                    throw NSError(domain: .errorDomain, code: 0, userInfo: [
                        NSLocalizedFailureReasonErrorKey: "Attribute destination not configured properly!"
                    ])
                }
            }
        }

        try traversePropertyMappings { mapping, name in
            guard let expression = mapping.valueExpression else { return }
            let context: NSMutableDictionary = ["source": source]
            guard let value = expression.expressionValue(with: source, context: context) else { return }

            attachment.setValue(value, forKey: name)
        }

        if let image = source.value(forKey: "image") as? UIImage {
            attachment.setValue(image.size.width, forKey: "width")
            attachment.setValue(image.size.height, forKey: "height")
        }

        let body = source.value(forKeyPath: "note.body") as? NSString ?? ""
        attachment.setValue(body.substring(to: 80), forKey: "caption")

        manager.associate(sourceInstance: source, withDestinationInstance: attachment, for: mapping)
    }
}
