// swiftlint:disable all
import Foundation
import CoreData

public extension Camper {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Camper> {
        return NSFetchRequest<Camper>(entityName: "Camper")
    }
    
    @NSManaged var fullName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var reservations: Reservation?
    
}
