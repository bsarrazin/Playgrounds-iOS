import Foundation
import CoreData

protocol CoreDataUsing: AnyObject {
    var context: NSManagedObjectContext? { get set }
}

class CoreDataStack {
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    lazy var context: NSManagedObjectContext = container.viewContext
    var makeBackgroundContext: NSManagedObjectContext { container.newBackgroundContext() }

    var storeURL: URL {
        let storePaths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let storePath = storePaths[0] as NSString
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(
                atPath: storePath as String,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            print("Error creating storePath \(storePath): \(error)")
        }
        
        let sqliteFilePath = storePath.appendingPathComponent("UnCloudNotesDataModel.sqlite")
        return URL(fileURLWithPath: sqliteFilePath)
    }
    
    lazy var storeDescription: NSPersistentStoreDescription = {
        let desc = NSPersistentStoreDescription(url: storeURL)
        desc.shouldMigrateStoreAutomatically = true
        desc.shouldInferMappingModelAutomatically = false
        return desc
    }()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
