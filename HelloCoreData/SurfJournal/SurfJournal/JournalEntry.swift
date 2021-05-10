import Foundation
import CoreData

class JournalEntry: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }
    
    @NSManaged var date: Date?
    @NSManaged var height: String?
    @NSManaged var period: String?
    @NSManaged var wind: String?
    @NSManaged var location: String?
    @NSManaged var rating: NSNumber?
}
