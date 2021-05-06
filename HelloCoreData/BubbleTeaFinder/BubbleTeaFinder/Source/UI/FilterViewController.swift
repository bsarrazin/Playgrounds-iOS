import CoreData
import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func viewController(_ viewController: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?)
}

class FilterViewController: UITableViewController {
    @IBOutlet weak var firstPriceCategoryLabel: UILabel!
    @IBOutlet weak var secondPriceCategoryLabel: UILabel!
    @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
    @IBOutlet weak var numDealsLabel: UILabel!

    // MARK: - Price section
    @IBOutlet weak var cheapVenueCell: UITableViewCell!
    @IBOutlet weak var moderateVenueCell: UITableViewCell!
    @IBOutlet weak var expensiveVenueCell: UITableViewCell!

    // MARK: - Most popular section
    @IBOutlet weak var offeringDealCell: UITableViewCell!
    @IBOutlet weak var walkingDistanceCell: UITableViewCell!
    @IBOutlet weak var userTipsCell: UITableViewCell!

    // MARK: - Sort section
    @IBOutlet weak var nameAZSortCell: UITableViewCell!
    @IBOutlet weak var nameZASortCell: UITableViewCell!
    @IBOutlet weak var distanceSortCell: UITableViewCell!
    @IBOutlet weak var priceSortCell: UITableViewCell!

    private var sortDescriptor: NSSortDescriptor?
    private var predicate: NSPredicate?
    var stack: CoreDataStack!
    weak var delegate: FilterViewControllerDelegate?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        populateCheapVenueCountLabel()
        populateModerateVenueCountLabel()
        populateExpensiveVenueCountLabel()
        populateDealsCountLabel()
    }

    private func populateCheapVenueCountLabel() {
        let request = NSFetchRequest<NSNumber>(entityName: "Venue")
        request.resultType = .countResultType
        request.predicate = .cheap

        do {
            let result = try stack.context.fetch(request)
            let count = result.first?.intValue ?? 0
            let pluralized = count == 1 ? "place" : "places"
            firstPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
        } catch let error as NSError {
            print("Could not fetch. \(error),\(error.userInfo)")
        }
    }
    private func populateModerateVenueCountLabel() {
        let request = NSFetchRequest<NSNumber>(entityName: "Venue")
        request.resultType = .countResultType
        request.predicate = .moderate

        do {
            let result = try stack.context.fetch(request)
            let count = result.first?.intValue ?? 0
            let pluralized = count == 1 ? "place" : "places"
            secondPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
        } catch let error as NSError {
            print("Could not fetch. \(error),\(error.userInfo)")
        }
    }
    private func populateExpensiveVenueCountLabel() {
        let request: NSFetchRequest<Venue> = Venue.fetchRequest()
        request.predicate = .expensive

        do {
            let count = try stack.context.count(for: request)
            let pluralized = count == 1 ? "place" : "places"
            thirdPriceCategoryLabel.text = "\(count) bubble tea \(pluralized)"
        } catch let error as NSError {
            print("Could not fetch. \(error),\(error.userInfo)")
        }
    }
    private func populateDealsCountLabel() {
        let request = NSFetchRequest<NSDictionary>(entityName: "Venue")
        request.resultType = .dictionaryResultType

        let special = NSExpression(forKeyPath: #keyPath(Venue.specialCount))
        let sum = NSExpressionDescription()
        sum.name = "sum"
        sum.expression = NSExpression(forFunction: "sum:", arguments: [special])
        sum.expressionResultType = .integer32AttributeType
        request.propertiesToFetch = [sum]

        do {
            let result = try stack.context.fetch(request)
            let dict = result.first
            let sum = dict?["sum"] as? Int ?? 0
            let pluralized = sum == 1 ? "deal" : "deals"
            numDealsLabel.text = "\(sum) \(pluralized)"
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - IBActions
extension FilterViewController {
    @IBAction func search(_ sender: UIBarButtonItem) {
        delegate?.viewController(self, didSelectPredicate: predicate, sortDescriptor: sortDescriptor)

        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath)
            else { return }

        switch cell {
        // Filter
        case cheapVenueCell: predicate = .cheap
        case moderateVenueCell: predicate = .moderate
        case expensiveVenueCell: predicate = .expensive
        case offeringDealCell: predicate = .specialCount
        case walkingDistanceCell: predicate = .walkingDistancePredicate
        case userTipsCell: predicate = .hasUserTipsPredicate

        // Sort
        case nameAZSortCell: sortDescriptor = .nameSortDescriptor
        case nameZASortCell:
            sortDescriptor = NSSortDescriptor.nameSortDescriptor.reversedSortDescriptor as? NSSortDescriptor
        case distanceSortCell:
            sortDescriptor = .distanceSortDescriptor
        case priceSortCell:
            sortDescriptor = .priceSortDescriptor
        default: break
        }

        cell.accessoryType = .checkmark
    }
}

extension NSPredicate {
    static var cheap: NSPredicate {
        return .init(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$")
    }
    static var moderate: NSPredicate {
        return .init(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$")
    }
    static var expensive: NSPredicate {
        return .init(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$$")
    }
    static var specialCount: NSPredicate {
        return .init(format: "%K > 0", #keyPath(Venue.specialCount))
    }
    static var walkingDistancePredicate: NSPredicate {
        return .init(format: "%K < 500", #keyPath(Venue.location.distance))
    }
    static var hasUserTipsPredicate: NSPredicate {
        return .init(format: "%K > 0", #keyPath(Venue.stats.tipCount))
    }
}

extension NSSortDescriptor {
    static var nameSortDescriptor: NSSortDescriptor {
        return .init(
            key: #keyPath(Venue.name),
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
    }
    static var distanceSortDescriptor: NSSortDescriptor {
        return .init(
            key: #keyPath(Venue.location.distance),
            ascending: true
        )
    }
    static var priceSortDescriptor: NSSortDescriptor {
        return .init(
            key: #keyPath(Venue.priceInfo.priceCategory),
            ascending: true
        )
    }
}
