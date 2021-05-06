import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDataSource, FilterViewControllerDelegate {
    // MARK: - Properties
    private let filterViewControllerSegueIdentifier = "toFilterViewController"
    private let venueCellIdentifier = "VenueCell"

    lazy var stack = CoreDataStack(name: "BubbleTeaFinder")
    private var asyncRequest: NSAsynchronousFetchRequest<Venue>?
    private var request: NSFetchRequest<Venue>?
    private var venues: [Venue] = []

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        importJSONSeedDataIfNeeded()

        let batch = NSBatchUpdateRequest(entityName: "Venue")
        batch.propertiesToUpdate = [#keyPath(Venue.favorite): true]
        batch.affectedStores = stack.context.persistentStoreCoordinator?.persistentStores
        batch.resultType = .updatedObjectsCountResultType

        do {
            let result = try stack.context.execute(batch)
            print("Records updated \(String(describing: result))")
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }

        request = Venue.fetchRequest()

        asyncRequest = .init(fetchRequest: request!) { [weak self] result in
            guard let self = self, let venues = result.finalResult
                else { return }

            self.venues = venues
            self.tableView.reloadData()
        }


        do {
            try stack.context.execute(asyncRequest!)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        fetchAndReload()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == filterViewControllerSegueIdentifier {
            let nav = segue.destination as? UINavigationController
            let filter = nav?.topViewController as? FilterViewController
            filter?.stack = stack
            filter?.delegate = self
        }
    }

    // MARK: - IBActions
    @IBAction func unwindToVenueListViewController(_ segue: UIStoryboardSegue) {
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: venueCellIdentifier, for: indexPath)
        let venue = venues[indexPath.row]
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = venue.priceInfo?.priceCategory
        return cell
    }

    // MARK: - FilterViewControllerDelegate
    func viewController(_ viewController: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
        guard let request = request
            else { return }

        request.predicate = nil
        request.sortDescriptors = nil

        request.predicate = predicate
        request.sortDescriptors = sortDescriptor == nil ? nil : [sortDescriptor!]

        fetchAndReload()
    }
}

// MARK: - Data loading
extension ViewController {
    func fetchAndReload() {
        guard let request = asyncRequest else { return }

        do {
            try stack.context.execute(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func importJSONSeedDataIfNeeded() {
        let fetchRequest = NSFetchRequest<Venue>(entityName: "Venue")

        do {
            let venueCount = try stack.context.count(for: fetchRequest)
            guard venueCount == 0 else { return }
            try importJSONSeedData()
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
    }

    func importJSONSeedData() throws {
        // swiftlint:disable:next force_unwrapping
        let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")!
        let jsonData = try Data(contentsOf: jsonURL)

        guard
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: [.fragmentsAllowed]) as? [String: Any],
            let responseDict = jsonDict["response"] as? [String: Any],
            let jsonArray = responseDict["venues"] as? [[String: Any]]
        else {
            return
        }

        for jsonDictionary in jsonArray {
            guard
                let contactDict = jsonDictionary["contact"] as? [String: String],
                let specialsDict = jsonDictionary["specials"] as? [String: Any],
                let locationDict = jsonDictionary["location"] as? [String: Any],
                let priceDict = jsonDictionary["price"] as? [String: Any],
                let statsDict = jsonDictionary["stats"] as? [String: Any]
            else {
                continue
            }

            let venueName = jsonDictionary["name"] as? String
            let venuePhone = contactDict["phone"]
            let specialCount = specialsDict["count"] as? Int32 ?? 0

            let location = Location(context: stack.context)
            location.address = locationDict["address"] as? String
            location.city = locationDict["city"] as? String
            location.state = locationDict["state"] as? String
            location.zipcode = locationDict["postalCode"] as? String
            location.distance = locationDict["distance"] as? Float ?? 0

            let category = Category(context: stack.context)

            let priceInfo = PriceInfo(context: stack.context)
            priceInfo.priceCategory = priceDict["currency"] as? String

            let stats = Stats(context: stack.context)
            stats.checkinsCount = statsDict["checkinsCount"] as? Int32 ?? 0
            stats.tipCount = statsDict["tipCount"] as? Int32 ?? 0

            let venue = Venue(context: stack.context)
            venue.name = venueName
            venue.phone = venuePhone
            venue.specialCount = specialCount
            venue.location = location
            venue.category = category
            venue.priceInfo = priceInfo
            venue.stats = stats
        }

        stack.save()
    }
}
