// swiftlint:disable all
import Foundation
import CoreData

public extension CampSite {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CampSite> {
        return NSFetchRequest<CampSite>(entityName: "CampSite")
    }
    
    @NSManaged var electricity: NSNumber?
    @NSManaged var siteNumber: NSNumber?
    @NSManaged var water: NSNumber?
    @NSManaged var reservations: Reservation?
    
}
