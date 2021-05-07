import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        if let splitController = window?.rootViewController as? UISplitViewController {
            splitController.delegate = self
        }
        return true
    }
}

// MARK: - UISplitViewControllerDelegate
extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNoteDetail = secondaryViewController as? NoteDetailViewController else {
            return false
        }

        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return secondaryAsNoteDetail.note == nil
    }
}
