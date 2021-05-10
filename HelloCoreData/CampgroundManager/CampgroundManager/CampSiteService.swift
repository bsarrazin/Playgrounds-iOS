import Foundation
import CoreData

public final class CampSiteService {
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
extension CampSiteService {
    public func addCampSite(_ siteNumber: NSNumber, electricity: Bool, water: Bool) -> CampSite {
        let campSite = CampSite(context: managedObjectContext)
        campSite.siteNumber = siteNumber
        campSite.electricity = NSNumber(value: electricity)
        campSite.water = NSNumber(value: water)

        coreDataStack.saveContext(managedObjectContext)

        return campSite
    }

    public func deleteCampSite(_ siteNumber: NSNumber) {
        // TODO : Not yet implemented
    }

    public func getCampSite(_ siteNumber: NSNumber) -> CampSite? {
        // TODO : Not yet implemented

        return nil
    }

    public func getCampSites() -> [CampSite] {
        let fetchRequest: NSFetchRequest<CampSite> = CampSite.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "siteNumber", ascending: true)]

        var results: [CampSite]
        do {
            try results = managedObjectContext.fetch(fetchRequest)
        } catch {
            results = []
        }

        return results
    }

    public func getNextCampSiteNumber() -> NSNumber {
        let sites = getCampSites()

        if !sites.isEmpty,
           let lastSiteNumber = sites.last?.siteNumber {
            return NSNumber(value: lastSiteNumber.intValue + 1)
        }

        return 1
    }
}
