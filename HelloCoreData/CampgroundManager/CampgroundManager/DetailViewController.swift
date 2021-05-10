import UIKit

class DetailViewController: UIViewController {
    // MARK: Properties
    var detailItem: CampSite? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

// MARK: Internal
extension DetailViewController {
    /// Update the user interface for the detail item.
    func configureView() {
        guard let detailItem = detailItem,
              let detailDescriptionLabel = detailDescriptionLabel,
              let siteNumber = detailItem.siteNumber else {
            return
        }
        
        detailDescriptionLabel.text = "Campsite number: \(siteNumber)"
    }
}
