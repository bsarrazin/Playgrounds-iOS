import UIKit
import CoreData

class NotesListViewController: UITableViewController {
    // MARK: - Properties
    private lazy var stack = CoreDataStack(name: "UnCloudNotesDataModel")

    private lazy var notes: NSFetchedResultsController<Note> = {
        let context = stack.context
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.dateCreated), ascending: false)]

        let notes = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        notes.delegate = self
        return notes
    }()

    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            try notes.performFetch()
        } catch {
            print("Error: \(error)")
        }

        tableView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
           let viewController = navController.topViewController as? CoreDataUsing {
            viewController.context = stack.makeBackgroundContext
        }

        if let detailView = segue.destination as? NoteDisplayable,
           let selectedIndex = tableView.indexPathForSelectedRow {
            detailView.note = notes.object(at: selectedIndex)
        }
    }
}

// MARK: - IBActions
extension NotesListViewController {
    @IBAction func unwindToNotesList(_ segue: UIStoryboardSegue) {
        print("Unwinding to Notes List")

        stack.save()
    }
}

// MARK: - UITableViewDataSource
extension NotesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objects = notes.fetchedObjects
        return objects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        cell.note = notes.object(at: indexPath)
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension NotesListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let wrapIndexPath: (IndexPath?) -> [IndexPath] = { $0.map { [$0] } ?? [] }

        switch type {
        case .insert: tableView.insertRows(at: wrapIndexPath(newIndexPath), with: .automatic)
        case .delete: tableView.deleteRows(at: wrapIndexPath(indexPath), with: .automatic)
        case .update: tableView.reloadRows(at: wrapIndexPath(indexPath), with: .none)
        default: break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
