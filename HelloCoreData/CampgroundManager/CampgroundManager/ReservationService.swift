import Foundation
import CoreData

public final class ReservationService {
    // MARK: Properties
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    // MARK: Initializers
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

// MARK: Public
extension ReservationService {
    public func reserveCampSite(_ campSite: CampSite, camper: Camper, date: Date, numberOfNights: Int) -> (reservation: Reservation?, error: NSError?) {
        let reservation = Reservation(context: managedObjectContext)
        reservation.camper = camper
        reservation.campSite = campSite
        reservation.dateFrom = date
        
        var dateComponents = DateComponents()
        dateComponents.day = numberOfNights
        
        let calendar = Calendar.current
        let toDate = calendar.date(byAdding: dateComponents, to: date)
        reservation.dateTo = toDate
        
        // Some complex logic here to determine if reservation is valid or if there are conflicts
        let registrationError: NSError? = nil
        
        reservation.status = "Reserved"
        
        coreDataStack.saveContext(managedObjectContext)
        
        // Error here would be a custom error to explain a failed reservation possibly
        return (reservation, registrationError)
    }
}
