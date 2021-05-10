import UIKit
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties
    var window: UIWindow?
    let coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Main is the name of storyboard
        window = UIWindow()
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        guard let splitViewController = window?.rootViewController as? UISplitViewController,
              let navigationController = splitViewController.viewControllers.last as? UINavigationController else {
            fatalError("Application storyboard is not setup correctly, application mis-configuration")
        }

        navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self

        guard let masterNavigationController = splitViewController.viewControllers.first as? UINavigationController,
              let controller = masterNavigationController.topViewController as? MasterViewController else {
            fatalError("Application storyboard is not setup correctly, application mis-configuration")
        }

        controller.managedObjectContext = coreDataStack.mainContext
        return true
    }
}

// MARK: UISplitViewControllerDelegate
extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController,
              let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController,
              topAsDetailController.detailItem == nil else {
            return false
        }

        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return true
    }
}
