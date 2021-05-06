import CoreData

extension NSFetchRequest where ResultType == Dog {
    static var dog: NSFetchRequest<Dog> { NSFetchRequest(entityName: "Dog") }
}

extension NSFetchRequest where ResultType == Walk {
    static var walk: NSFetchRequest<Walk> { NSFetchRequest(entityName: "Walk") }
}
