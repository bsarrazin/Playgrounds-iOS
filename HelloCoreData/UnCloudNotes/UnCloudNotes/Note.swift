// swiftlint:disable all
import Foundation
import CoreData
import UIKit

class Note: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var body: String
    @NSManaged var dateCreated: Date!
    @NSManaged var displayIndex: NSNumber!
    @NSManaged var attachments: Set<Attachment>?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        dateCreated = Date()
    }
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
}

extension Note {
    var image: UIImage? {
        let attachment = latestAttachment as? ImageAttachment
        return attachment?.image
    }
    var latestAttachment: Attachment? {
        guard let attachments = attachments, let first = attachments.first
            else { return nil }

        return Array(attachments).reduce(first) { first, second in
            guard let a = first.created, let b = second.created
                else { return first }

            return a.compare(b) == .orderedAscending ? first : second
        }
    }
}
