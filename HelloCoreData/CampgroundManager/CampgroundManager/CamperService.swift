import Foundation
import CoreData

public final class CamperService {
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
extension CamperService {
    public func addCamper(_ name: String, phoneNumber: String) -> Camper? {
        let camper = Camper(context: managedObjectContext)
        camper.fullName = name
        camper.phoneNumber = phoneNumber
        
        coreDataStack.saveContext(managedObjectContext)
        
        return camper
    }
}
