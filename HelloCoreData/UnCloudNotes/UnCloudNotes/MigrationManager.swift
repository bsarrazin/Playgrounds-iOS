import CoreData
import Foundation

class MigrationManager {

    // MARK: - Properties
    let enableMigrations: Bool
    let modelName: String
    let storeName: String = .modelName
    var stack: CoreDataStack {
        guard enableMigrations, !store(at: storeURL, isCompatibleWithModel: currentModel)
            else { return .init(name: .modelName) }

        performMigration()

        return .init(name: .modelName)
    }

    private var appSupportURL: URL {
        FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first!
    }
    private lazy var storeURL: URL = {
        let filename = .modelName + ".sqlite"
        return .init(fileURLWithPath: filename, relativeTo: appSupportURL)
    }()

    private var model: NSManagedObjectModel? {
        .modelVersions(forModelName: .modelName)
            .first { store(at: storeURL, isCompatibleWithModel: $0) }
    }

    private lazy var currentModel: NSManagedObjectModel = .model(name: .modelName)

    init(modelName: String, enableMigrations: Bool = false) {
        self.enableMigrations = enableMigrations
        self.modelName = modelName
    }

    private func store(at url: URL, isCompatibleWithModel model: NSManagedObjectModel) -> Bool {
        let metadata = metadataForStore(at: url)
        return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
    }

    private func metadataForStore(at url: URL) -> [String: Any] {
        let metadata: [String: Any]

        do {
            metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
                ofType: NSSQLiteStoreType,
                at: url,
                options: nil
            )
        } catch {
            metadata = [:]
            print("Error retrieving metadata for store at URL: \(url): \(error)")
        }

        return metadata
    }

    func performMigration() {
        // guard currentModel.isV4 else { fatalError("Can only support migrations to version 4!") }
        guard let model = model else { return }

        switch model {
        case .v1:
            migrateStore(at: storeURL, from: model, to: .v2)
            performMigration()

        case .v2:
            let dest: NSManagedObjectModel = .v3
            let mapping = NSMappingModel(from: nil, forSourceModel: model, destinationModel: dest)
            migrateStore(at: storeURL, from: model, to: dest, mapping: mapping)
            performMigration()

        case .v3:
            let dest: NSManagedObjectModel = .v4
            let mapping = NSMappingModel(from: nil, forSourceModel: model, destinationModel: dest)
            migrateStore(at: storeURL, from: model, to: dest, mapping: mapping)
            performMigration()

        default:
            print("Already running CoreData using version4!")
        }
    }

    private func migrateStore(at url: URL, from source: NSManagedObjectModel, to destination: NSManagedObjectModel, mapping: NSMappingModel? = nil) {
        let manager = NSMigrationManager(sourceModel: source, destinationModel: destination)

        let mappingModel = mapping != nil
            ? mapping!
            : try! NSMappingModel.inferredMappingModel(
                forSourceModel: source,
                destinationModel: destination
            )

        let targetURL = storeURL.deletingLastPathComponent()
        let destinationName = storeURL.lastPathComponent + "~1"
        let destinationURL = targetURL.appendingPathComponent(destinationName)

        print("From Model: \(source.entityVersionHashesByName)")
        print("To Model: \(destination.entityVersionHashesByName)")
        print("Migrating store \(storeURL) to \(destinationURL)")
        print("Mapping model: \(String(describing: mappingModel))")

        let success: Bool
        do {
            try manager.migrateStore(
                from: storeURL,
                sourceType: NSSQLiteStoreType,
                options: nil,
                with: mappingModel,
                toDestinationURL: destinationURL,
                destinationType: NSSQLiteStoreType,
                destinationOptions: nil
            )
            success = true
        } catch {
            success = false
            print("Migration failed: \(error)")
        }

        guard success else { return }

        let fileManager: FileManager = .default
        do {
            try fileManager.removeItem(at: storeURL)
            try fileManager.moveItem(at: destinationURL, to: storeURL)
        } catch {
            print("Error mgirating: \(error)")
        }
    }
}

extension NSManagedObjectModel {
    static func model(name: String, in bundle: Bundle = .main) -> NSManagedObjectModel {
        bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap(NSManagedObjectModel.init)
            ?? .init()
    }
    private static func modelURLs(in folder: String) -> [URL] {
        Bundle.main.urls(
            forResourcesWithExtension: "mom",
            subdirectory: "\(folder).momd"
        ) ?? []
    }

    static func modelVersions(forModelName name: String) -> [NSManagedObjectModel] {
        modelURLs(in: name).compactMap(NSManagedObjectModel.init)
    }

    static func uncloudNotesModel(modelName name: String) -> NSManagedObjectModel {
        let model = modelURLs(in: .modelName)
            .first { $0.lastPathComponent == "\(name).mom" }
            .flatMap(NSManagedObjectModel.init)

        return model ?? .init()
    }

    static var v1: NSManagedObjectModel { uncloudNotesModel(modelName: .modelName) }
    var isV1: Bool { self == Self.v1 }
    static var v2: NSManagedObjectModel { uncloudNotesModel(modelName: .modelName + "2") }
    var isV2: Bool { self == Self.v2 }
    static var v3: NSManagedObjectModel { uncloudNotesModel(modelName: .modelName + "3") }
    var isV3: Bool { self == Self.v3 }
    static var v4: NSManagedObjectModel { uncloudNotesModel(modelName: .modelName + "4") }
    var isV4: Bool { self == Self.v4 }

    static func == (first: NSManagedObjectModel, second: NSManagedObjectModel) -> Bool {
        return first.entitiesByName == second.entitiesByName
    }
}

private extension String {
    static let modelName = "UnCloudNotesDataModel"
}
