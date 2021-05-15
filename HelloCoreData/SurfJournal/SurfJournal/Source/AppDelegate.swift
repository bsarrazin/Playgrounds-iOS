import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "SurfJournalModel")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = coreDataStack.mainContext

        guard
            let navigationController = window?.rootViewController as? UINavigationController,
            let listViewController = navigationController.topViewController as? JournalListViewController
        else { fatalError("Application Storyboard mis-configuration") }

        listViewController.stack = coreDataStack

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}
