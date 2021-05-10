// swiftlint:disable all
import Foundation
import CoreData

public extension Reservation {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

    @NSManaged var dateFrom: Date?
    @NSManaged var dateTo: Date?
    @NSManaged var status: String?
    @NSManaged var camper: Camper?
    @NSManaged var campSite: CampSite?

}
