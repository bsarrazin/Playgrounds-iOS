import CoreData
import Foundation

class CoreDataStack {

    private let name: String

    init(name: String) {
        self.name = name
    }

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores { description, error in
            guard let error = error as NSError? else { return }
            print("Unexpected error: \(error), \(error.userInfo)")
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = { container.viewContext }()

    func save() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Unexpected error: \(error), \(error.userInfo)")
        }
    }
}
