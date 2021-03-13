/*:
 # Method Dispatch
 
 ### What's that?
 Method Dispatch is how a program selects which instructions to execute when invoking a method.
 
 ### Types of Dispatch
 
 1. Direct Dispatch
 - fastest
 - most optimized
 - also called static dispatch
 1. Table Dispatch
 - most common of dynamic behaviour
 - slow compared to Direct Dispatch
 - most languages call this the "virtual" table, but Swift calls it the "witness" table
 - uses an array of function pointers to reach method in the class
 - con: extensions cannot extend the witness table
 - every subclass has its own copy with a different function pointer for every method
 - new subclass methods are appended at the end of the table
 - the table is consulted **at runtime** to determine which method to run
 ```swift
 class ParentClass {
    func method1() {}
    func method2() {}
 }
 
 +-------+-------------+
 | 0xA00 | ParentClass |
 +-------+-------------|
 | 0x121 | method1     |
 | 0x122 | method2     |
 
 class ChildClass: ParentClass {
    override func method1() {}
    func method3() {}
 }
 
 +-------+-------------+
 | 0xB00 | ChildClass  |
 +-------+-------------|
 | 0x121 | method1     |
 | 0x222 | method2     |
 | 0x223 | method3     |
 
 ```
 1. Message Dispatch
 - most dynamic option
 - slowest option, but has fast cache layer
 - Objective C is all based on this
 - KVO, UIAppearance, Core Data, etc...
 - dispatch behaviour can be modified at run time (swizzling)
 - runtime will crawl the class hierarchy to determine which method to invoke
 ```swift
 class ParentClass {
    dynamic func method1() {}
    dynamic func method2() {}
 }
 
 class ChildClass: ParentClass {
     override func method1() {}
     dynamic func method3() {}
 }
 
 +-------+-------------+
 |       | ParentClass |<-|
 +-------+-------------|  |
 |       | super       |  |
 | 0x121 | method1     |  |  +-------+-------------+
 | 0x122 | method2     |  |  |       | ChildClass  |
                          |  +-------+-------------+
                          |--|       | super       |
                             | 0x222 | method2     |
                             | 0x223 | method3     |
 ```
 */

import UIKit

/*:
 ## Location Matters
 ```
                     +---------------------+-----------+
                     | Initial Declaration | Extension |
 +-------------------+---------------------+-----------+
 | Value Type        | Direct              | Direct    |
 +-------------------+---------------------+-----------+
 | Protocol          | Table               | Direct    |
 +-------------------+---------------------+-----------+
 | Class             | Table               | Direct    |
 +-------------------+---------------------+-----------+
 | NSObject Subclass | Table               | Message   |
 +-------------------+---------------------+-----------+
 ```
 */

class MyClass {
    func mainMethod() {} // uses table dispatch
}
extension MyClass {
    func extensionMethod() {} // uses direct dispatch
}

/*:
 ## Reference Type Matters
 */

protocol DirectDispachProtocol { }
struct DirectDispatchStruct: DirectDispachProtocol { }
extension DirectDispachProtocol { func extensionMethod() -> String { return "in protocol" } }
extension DirectDispatchStruct { func extensionMethod() -> String { return "in struct" } }
let directDispatchStruct = DirectDispatchStruct()
let directDispatchProtocol: DirectDispachProtocol = directDispatchStruct
directDispatchStruct.extensionMethod()   // -> in struct
directDispatchProtocol.extensionMethod() // -> in protocol

protocol TableDispatchProtocol { func extensionMethod() -> String } // THIS LINE IS THE DIFFERENCE
struct TableDispatchStruct: TableDispatchProtocol { }
extension TableDispatchProtocol { func extensionMethod() -> String { return "in protocol" } }
extension TableDispatchStruct { func extensionMethod() -> String { return "in struct" } }
let tableDispatchStruct = TableDispatchStruct()
let tableDispatchProto: TableDispatchProtocol = tableDispatchStruct
tableDispatchStruct.extensionMethod() // -> in struct
tableDispatchProto.extensionMethod()  // -> in struct

/*:
 ## Forcing/Specifying Dispatch Behaviour
 ```
 +-------------------------------------+--------------------------------------------------------------------------+
 | final                               | Forces the direct dispatch behaviour                                     |
 +-------------------------------------+--------------------------------------------------------------------------+
 | dynamic                             | Forces the message dispatch behaviour                                    |
 +-------------------------------------+--------------------------------------------------------------------------+
 | @objc                               | Does NOT change the dispatch behaviour                                   |
 +-------------------------------------+--------------------------------------------------------------------------+
 | @nonobjc (avoid, use final instead) | DOES change the dispatch behaviour defined in the Location Matters table |
 +-------------------------------------+--------------------------------------------------------------------------+
 | final @objc                         | Forces the direct dispatch behaviour AND exposes to ObjC                 |
 +-------------------------------------+--------------------------------------------------------------------------+
 | @inline (avoid, just a hint)        | Provides a hint that the compiler can use to alter the direct dispatch   |
 +-------------------------------------+--------------------------------------------------------------------------+
 ```
 */

class SpecifiedDispatchBehaviour {
    final func forcedDirectDispatch() {} // also hides it from ObjC, and will not generate a selector
    @objc dynamic func forcedMessageDispatch() {} // makes it available to ObjC, can be overriden
}
extension SpecifiedDispatchBehaviour {
    @objc(objc_name_for_method) dynamic func dynamicExtensionMethod() {} // forced message dispatch -> can be overridden in subclasses
}
class SubclassSpecifiedDispatchBehaviour: SpecifiedDispatchBehaviour {
    override func dynamicExtensionMethod() { super.dynamicExtensionMethod() } // overridden
}

/*:
 ## Optimizations
 
 Swift will try to optimize method dispatch whenever it can.
 > e.g. if you have a method that is never overridden, Swift will notice this and will use direct dispatch if it can
 
 > Another thing to be aware of when using more dynamic Foundation features is that this optimization can silently break KVO if you do not use the dynamic keyword.
 > If a property is observed with KVO, and the property is upgraded to direct dispatch, the code will still compile, but the dynamically generated KVO method will not be triggered.
 
 */

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign In",
            style: .plain,
            target: nil,
            action: #selector(ViewController.signInAction)
        )
    }
    
    // Because of the optimization done by Swift (no subclass forces direct dispatch)
    // We need to add @objc to make it dynamic again (works because it was originally dynamic)
    @objc private func signInAction() {}
}

/*:
 ## In Summary
 ```
               +----------------------+---------------------+-----------------------------+
               | Direct               | Table               | Message                     |
 +-------------+----------------------+---------------------+-----------------------------+
 | NSObject    | @nonobjc OR final    | Initial Declaration | Extensions AND dynamic      |
 +-------------+----------------------+---------------------+-----------------------------+
 | Class       | Extensions AND final | Initial Declaration | dynamic                     |
 +-------------+----------------------+---------------------+-----------------------------+
 | Protocol    | Extensions           | Initial Declaration | ObjC Declarations AND @objc |
 +-------------+----------------------+---------------------+-----------------------------+
 | Value Type  | All Methods          | N/A                 | N/A                         |
 +-------------+--------------------------------------------------------------------------+
 ```
 */


/*:
 # WARNING!!!!
 > Casting to protocol WILL use protocol extension implementation!
 */

protocol Greetable {
    func sayHi() -> String
}
extension Greetable {
    func sayHi() -> String {
        return "Greetable Hello!"
    }
}
class Person: Greetable { }
class LoudPerson: Person {
    func sayHi() -> String {
        return "LOUDPERSON HELLO!"
    }
}

let loudPerson = LoudPerson()
loudPerson.sayHi() // LOUDPERSON HELLO!
let person: Person = loudPerson
person.sayHi() // Greetable Hello!
type(of: person) // LoudPerson.Type

