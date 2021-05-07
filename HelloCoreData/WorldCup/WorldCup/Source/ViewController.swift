import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: - Properties
    private let teamCellIdentifier = "teamCellReuseIdentifier"
    private var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>?
    lazy var  stack = CoreDataStack(modelName: "WorldCup")
    lazy var results: NSFetchedResultsController<Team> = {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        request.sortDescriptors = [
            .init(key: #keyPath(Team.qualifyingZone), ascending: true),
            .init(key: #keyPath(Team.wins), ascending: false),
            .init(key: #keyPath(Team.teamName), ascending: true)
        ]
        return .init(
            fetchRequest: request,
            managedObjectContext: stack.context,
            sectionNameKeyPath: #keyPath(Team.qualifyingZone),
            cacheName: "worldCup"
        )
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = configureDataSource()
        results.delegate = self
        
        importJSONSeedDataIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        do {
            try results.performFetch()
        } catch let error as NSError {
            print("CoreData error: \(error), \(error.userInfo)")
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        guard case .motionShake = motion else { return }
        addButton.isEnabled = true
    }

    // MARK: - Actions
    @IBAction func addTeam(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Secret Team", message: "Add a new team", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Team Name"
        }
        alert.addTextField { field in
            field.placeholder = "Qualifying Zone"
        }

        let save = UIAlertAction(title: "Save", style: .default) { [stack] _ in
            guard let nameField = alert.textFields?.first, let zoneField = alert.textFields?.last
                else { return }

            let team = Team(context: stack.context)
            team.teamName = nameField.text
            team.qualifyingZone = zoneField.text
            team.imageName = "wenderland-flag"
            stack.save()
        }
        alert.addAction(save)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Internal
extension ViewController {
    func configure(cell: UITableViewCell, for team: Team) {
        guard let cell = cell as? TeamCell
            else { return }

        cell.teamLabel.text = team.teamName
        cell.scoreLabel.text = "Wins: \(team.wins)"

        if let name = team.imageName {
            cell.flagImageView.image = UIImage(named: name)
        } else {
            cell.flagImageView.image = nil
        }
    }
    func configureDataSource() -> UITableViewDiffableDataSource<String, NSManagedObjectID> {
        .init(tableView: tableView) { [unowned self] tableView, IndexPath, id in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.teamCellIdentifier, for: IndexPath)
            if let team = try? self.stack.context.existingObject(with: id) as? Team {
                self.configure(cell: cell, for: team)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = results.object(at: indexPath)
        team.wins += 1
        stack.save()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = results.sections?[section].name
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        dataSource?.apply(snapshot)
    }
}


// MARK: - Helper methods
extension ViewController {
    func importJSONSeedDataIfNeeded() {
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        let count = try? stack.context.count(for: fetchRequest)
        
        guard let teamCount = count,
              teamCount == 0 else {
            return
        }
        
        importJSONSeedData()
    }
    
    // swiftlint:disable force_unwrapping force_cast force_try
    func importJSONSeedData() {
        let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)
        
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [[String: Any]]
            
            for jsonDictionary in jsonArray {
                let teamName = jsonDictionary["teamName"] as! String
                let zone = jsonDictionary["qualifyingZone"] as! String
                let imageName = jsonDictionary["imageName"] as! String
                let wins = jsonDictionary["wins"] as! NSNumber
                
                let team = Team(context: stack.context)
                team.teamName = teamName
                team.imageName = imageName
                team.qualifyingZone = zone
                team.wins = wins.int32Value
            }
            
            stack.save()
            print("Imported \(jsonArray.count) teams")
        } catch let error as NSError {
            print("Error importing teams: \(error)")
        }
    }
    // swiftlint:enable force_unwrapping force_cast force_try
}
