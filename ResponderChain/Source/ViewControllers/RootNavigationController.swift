import UIKit

class RootNavigationController: UINavigationController {
    override func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    override func presentGreenView() {
        performSegue(withIdentifier: "PresentGreenView", sender: nil)
    }
}
