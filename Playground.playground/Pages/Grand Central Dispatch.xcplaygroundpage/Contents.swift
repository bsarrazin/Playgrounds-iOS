import Foundation
import PlaygroundSupport
import UIKit

/*:
 ### The Basics
 */

xexample("The Basics") { title in
    print("\(title): START")
    DispatchQueue.global(qos: .background).async { print("\(title): background thread") }
    DispatchQueue.main.async { print("\(title): main thread") }
    print("\(title): END")
}

xexample("UI Synchronous", queue: DispatchQueue.global(qos: .default)) { title in
    class ViewController: UIViewController {
        @IBOutlet var label: UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.label = UILabel()
        }
    }
    
    print("\(title): START")
    let viewController = ViewController()
    viewController.beginAppearanceTransition(true, animated: false)
    viewController.endAppearanceTransition()
    DispatchQueue.main.sync {
        print("\(title): updating label text")
        viewController.label.text = "test"
    }
    print("\(title): END")
}

/*:
 ### The Pitfalls
 */

xexample("Using Concurrent Queues") { title in
    func intensiveWork1() { print("\(title): Intensive Work 1") }
    func intensiveWork2() { print("\(title): Intensive Work 2") }
    
    print("\(title): START")
    
    func intensiveWork() {
        let queue = DispatchQueue.global(qos: .background)
        
        // The order is NOT guaranteed
        queue.async { intensiveWork1() }
        queue.async { intensiveWork2() }
        
        // The order IS guaranteed
        queue.async {
            intensiveWork1()
            intensiveWork2()
        }
    }
    intensiveWork()
    
    print("\(title): END")
}

xexample("Using Serial Queues") { title in
    func intensiveWork1() { print("\(title): Intensive Work 1") }
    func intensiveWork2() { print("\(title): Intensive Work 2") }
    
    print("\(title): START")
    
    func intensiveWork() {
        let queue = DispatchQueue(label: "com.trov.playgrounds.GrandCentralDispatch") // serial by default
        // The order IS guaranteed
        queue.async { intensiveWork1() }
        queue.async { intensiveWork2() }
    }
    intensiveWork()
    
    print("\(title): END")
}

// You cannot see the deadlock in a playground but rest assured that this code will halt execution
xexample("Dead Locks") { (title) in
    print("\(title): START")
    let serial = DispatchQueue(label: "com.trov.playgrounds.GrandCentralDispatch")
    serial.async {
        print("\(title): dispatch async")
        serial.sync { print("\(title): dispatch sync") } // cannot start until first async closure finishes
        // cannot finish until serial.sync is complete
    }
    print("\(title): END")
}

/*:
 ### Dispatch Groups
 > to force synchronous behaviour
 */

xexample("Dispatch Groups") { title in
    func intensiveWork1() { print("\(title): Intensive Work 1") }
    func intensiveWork2() { print("\(title): Intensive Work 2") }
    
    print("\(title): START")
    
    func intensiveWork() {
        let group = DispatchGroup()
        
        DispatchQueue.global(qos: .background).async(group: group) { intensiveWork1() }
        DispatchQueue.global(qos: .default).async(group: group) { intensiveWork2() }
        
        group.notify(queue: DispatchQueue.main) { print("\(title): Asynchronous Waiting") }
        group.wait(); print("\(title): Synchronous Waiting")
    }
    intensiveWork()
    print("\(title): END")
}

/*:
 ### Semaphores
 */

example("Proper Use Of Semaphores") { (title) in
    class Obj {
        private let semaphore = DispatchSemaphore(value: 1)
        private var ifThisCountGoesAbove100ThePlanetExplodes: Int = 0
        func incrementCountBy(amount: Int) {
            semaphore.wait()
            if ifThisCountGoesAbove100ThePlanetExplodes <= (100 - amount) {
                ifThisCountGoesAbove100ThePlanetExplodes += amount
            } else {
                ifThisCountGoesAbove100ThePlanetExplodes = 100
            }
            print(ifThisCountGoesAbove100ThePlanetExplodes)
            semaphore.signal()
        }
    }
    
    print("\(title): START")
    let obj = Obj()
    DispatchQueue.global(qos: .background).async {
        let amount = random(min: 0, max: 100)
        print("\(title): attempting to add \(amount)")
        obj.incrementCountBy(amount: amount)
    }
    DispatchQueue.global(qos: .default).async {
        let amount = random(min: 0, max: 100)
        print("\(title): attempting to add \(amount)")
        obj.incrementCountBy(amount: amount)
    }
    DispatchQueue.main.async {
        let amount = random(min: 0, max: 100)
        print("\(title): attempting to add \(amount)")
        obj.incrementCountBy(amount: amount)
    }
    print("\(title): END")
}

/*:
 ### Barriers
 */

xexample("Barriers") { (title) in
    print("\(title): START")
    let queue = DispatchQueue(label: "com.trov.playgrounds.GrandCentralDispatch", attributes: .concurrent)
    (0..<100).forEach {
        let i = $0
        queue.async {
            print("START: \(i)")
            print(i)
            print("END: \(i)")
        }
    }
    // WILL NOT WORK ON A GLOBAL QUEUE
    queue.sync(flags: .barrier)  { print("All Done!") }
    print("\(title): END")
}

PlaygroundPage.current.needsIndefiniteExecution = true

