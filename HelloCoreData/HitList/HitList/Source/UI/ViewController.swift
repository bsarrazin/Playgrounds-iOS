import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties
    private var people: [NSManagedObject] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellId)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let delegate = UIApplication.shared.delegate as? AppDelegate
            else { return }

        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Person")

        do {
            people = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Actions
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "New Name",
            message: "Add a new name",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let save = UIAlertAction(title: "Save", style: .default) { action in
            guard let textField = alert.textFields?.first, let name = textField.text
                else { return }

            self.save(name: name)
            self.tableView.reloadData()
        }

        alert.addTextField()
        alert.addAction(cancel)
        alert.addAction(save)

        present(alert, animated: true)
    }


    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellId, for: indexPath)

        cell.textLabel?.text = people[indexPath.row].value(forKey: "name") as? String

        return cell
    }

    // MARK: - Private
    private func save(name: String) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate
            else { return }

        let context = delegate.persistentContainer.viewContext
        let entity: NSEntityDescription = .entity(forEntityName: "Person", in: context)!
        let person: NSManagedObject = .init(entity: entity, insertInto: context)
        person.setValue(name, forKey: "name")

        do {
            try context.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

private extension String {
    static let cellId: String = "ViewControllerCellIdentifier"
}
