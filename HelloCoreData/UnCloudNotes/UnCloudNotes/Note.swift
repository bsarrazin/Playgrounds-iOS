// swiftlint:disable all
import Foundation
import CoreData
import UIKit

class Note: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var body: String
    @NSManaged var dateCreated: Date!
    @NSManaged var displayIndex: NSNumber!
    @NSManaged var image: UIImage?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        dateCreated = Date()
    }
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
}
