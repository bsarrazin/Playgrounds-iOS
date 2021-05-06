import Foundation
import CoreData

class CoreDataStack {
    private let name: String

    init(name: String) {
        self.name = name
    }

    lazy var context: NSManagedObjectContext = {
        return self.container.viewContext
    }()

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func save() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch let nserror as NSError {
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
