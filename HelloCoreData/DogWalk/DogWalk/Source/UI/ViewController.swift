import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    // MARK: - Properties
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    private lazy var stack = CoreDataStack(name: "DogWalk")
    private var dog: Dog?

    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let name = "Fido"
        let request: NSFetchRequest<Dog> = .dog
        request.predicate = .init(format: "%K == %@", #keyPath(Dog.name), name)

        do {
            let dogs = try stack.context.fetch(request)
            if dogs.isEmpty {
                dog = .init(context: stack.context)
                dog?.name = name
                stack.save()
            } else {
                dog = dogs.first
            }
        } catch let error as NSError {
            print("Unable to fetch. \(error), \(error.userInfo)")
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: - IBActions
    @IBAction func add(_ sender: UIBarButtonItem) {
        let walk = Walk(context: stack.context)
        walk.date = .init()

        dog?.addToWalks(walk)

        stack.save()
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dog?.walks?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard let walks = dog?.walks, let walk = walks[indexPath.row] as? Walk, let date = walk.date
            else { return cell }

        cell.textLabel?.text = formatter.string(from: date)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of Walks"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let walk = dog?.walks?[indexPath.row] as? Walk, case .delete = editingStyle
            else { return }

        stack.context.delete(walk)
        stack.save()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
