import CoreData
import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var wearButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!

    // MARK: - Properties
    var context: NSManagedObjectContext!
    var current: BowTie!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let delegate = UIApplication.shared.delegate as? AppDelegate
        context = delegate?.persistentContainer.viewContext

        seed()

        let request: NSFetchRequest<BowTie> = BowTie.fetchRequest()
        let title = segmentedControl.titleForSegment(at: 0) ?? ""
        request.predicate = .init(format: "%K = %@", argumentArray: [#keyPath(BowTie.searchKey), title])

        do {
            let result = try context.fetch(request)
            if let tie = result.first {
                current = tie
                populate(bowtie: tie)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - IBActions
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        guard let selected = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }

        let request: NSFetchRequest<BowTie> = BowTie.fetchRequest()
        request.predicate = .init(format: "%K = %@", argumentArray: [#keyPath(BowTie.searchKey), selected])

        do {
            let results = try context.fetch(request)
            current = results.first
            populate(bowtie: current)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction func wear(_ sender: UIButton) {
        current.timesWorn += 1
        current.lastWorn = .init()

        do {
            try context.save()
            populate(bowtie: current)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    @IBAction func rate(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "New Rating",
            message: "Rate this bow tie",
            preferredStyle: .alert
        )
        alert.addTextField { $0.keyboardType = .decimalPad }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let textField = alert.textFields?.first else { return }
            self.update(rating: textField.text)
        }

        alert.addAction(cancel)
        alert.addAction(save)

        present(alert, animated: true)
    }

    // MARK: - CRUD
    private func populate(bowtie: BowTie) {
        guard let data = bowtie.photoData, let last = bowtie.lastWorn, let tint = bowtie.tintColour
            else { return }

        imageView.image = .init(data: data)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating)/5"
        timesWornLabel.text = "# times worn: \(bowtie.timesWorn)"

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        lastWornLabel.text = "Last worn: " + formatter.string(from: last)

        favoriteLabel.isHidden = !bowtie.isFavourite
        view.tintColor = tint
    }
    private func update(rating: String?) {
        guard let string = rating, let new = Double(string) else { return }

        do {
            current.rating = new
            try context.save()
            populate(bowtie: current)
        } catch let error as NSError {
            guard error.domain == NSCocoaErrorDomain, error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError
                else { return print("Could not save. \(error), \(error.userInfo)")}

            rate(rateButton)
        }
    }
    private func seed() {
        let request: NSFetchRequest<BowTie> = BowTie.fetchRequest()
        request.predicate = .init(format: "searchKey != nil")

        let count = (try? context.count(for: request)) ?? 0

        guard count <= 0 else { return }

        let url = Bundle.main.url(forResource: "SampleData", withExtension: "plist")!
        let items = NSArray(contentsOf: url) ?? []
        let entity: NSEntityDescription = .entity(forEntityName: "BowTie", in: context)!

        for item in items {
            let dict = item as! [String: Any]
            let bowtie = BowTie(entity: entity, insertInto: context)
            bowtie.id = .init(uuidString: dict["id"] as! String)
            bowtie.name = dict["name"] as? String
            bowtie.searchKey = dict["searchKey"] as? String
            bowtie.rating = dict["rating"] as! Double

            let colorDict = dict["tintColor"] as! [String: Any]
            bowtie.tintColour = UIColor.color(dict: colorDict)

            let imageName = dict["imageName"] as? String
            let image = UIImage(named: imageName!)
            bowtie.photoData = image?.pngData()
            bowtie.lastWorn = dict["lastWorn"] as? Date

            let timesNumber = dict["timesWorn"] as! NSNumber
            bowtie.timesWorn = timesNumber.int32Value
            bowtie.isFavourite = dict["isFavorite"] as! Bool
            bowtie.url = URL(string: dict["url"] as! String)

        }
    }
}

extension UIColor {
    static func color(dict: [String: Any]) -> UIColor? {
        guard
            let red = dict["red"] as? NSNumber,
            let green = dict["green"] as? NSNumber,
            let blue = dict["blue"] as? NSNumber
        else { return nil }

        return .init(
            red: CGFloat(truncating: red) / 255.0,
            green: CGFloat(truncating: green) / 255.0,
            blue: CGFloat(truncating: blue) / 255.0,
            alpha: 1
        )
    }
}
