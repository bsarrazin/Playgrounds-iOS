import UIKit
import CoreData

class MasterViewController: UITableViewController {
    // MARK: Properties
    var detailViewController: DetailViewController?
    var managedObjectContext: NSManagedObjectContext?
    lazy var fetchedResultsController: NSFetchedResultsController<CampSite> = {
        let fetchRequest: NSFetchRequest<CampSite> = CampSite.fetchRequest()

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: #keyPath(CampSite.siteNumber), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        // swiftlint:disable force_unwrapping
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: "Master")
        frc.delegate = self
        // swiftlint:enable force_unwrapping
        do {
            try frc.performFetch()
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        return frc
    }()

    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        clearsSelectionOnViewWillAppear = false
        preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton

        guard let controllers = splitViewController?.viewControllers,
              let navigationController = controllers.last as? UINavigationController,
              let detailViewController = navigationController.topViewController as? DetailViewController else {
            return
        }

        self.detailViewController = detailViewController
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let navigationController = segue.destination as? UINavigationController,
                  let controller = navigationController.topViewController as? DetailViewController else {
                return
            }

            let object = fetchedResultsController.object(at: indexPath)
            controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

// MARK: Internal
extension MasterViewController {
    @objc func insertNewObject(_ sender: Any) {
        let context = fetchedResultsController.managedObjectContext
        let newCampSite = CampSite(context: context)
        newCampSite.siteNumber = 1

        // Save the context.
        do {
            try context.save()
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

// MARK: UITableViewDataSource
extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let campSite = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withCampSite: campSite)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard case(.delete) = editingStyle else { return }

        let context = fetchedResultsController.managedObjectContext
        context.delete(fetchedResultsController.object(at: indexPath))

        do {
            try context.save()
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

// MARK: Private
private extension MasterViewController {
    func configureCell(_ cell: UITableViewCell, withCampSite campSite: CampSite?) {
        guard let campSite = campSite,
              let siteNumber = campSite.siteNumber else {
            return
        }

        cell.textLabel?.text = String(describing: siteNumber)
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension MasterViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    // swiftlint:disable force_unwrapping
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withCampSite: anObject as? CampSite)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        @unknown default:
            return
        }
    }
    // swiftlint:enable force_unwrapping

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
