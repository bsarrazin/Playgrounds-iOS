import Foundation

protocol Row {
    associatedtype Model
    var sizeLabelText: String { get set }
    func configure(model: Model)
}

private class _AnyRowBase<Model>: Row {
    init() {
        guard type(of: self) != _AnyRowBase.self
            else { fatalError("_AnyRowBase<Model> instances cannot be created; you must create a subclass") }
    }
    
    func configure(model: Model) {
        fatalError("This function must be overridden")
    }
    
    var sizeLabelText: String {
        get { fatalError("This property must be overridden") }
        set { fatalError("This property must be overridden") }
    }
}

private final class _AnyRowBox<Concrete: Row>: _AnyRowBase<Concrete.Model> {
    var concrete: Concrete
    
    init(_ concrete: Concrete) {
        self.concrete = concrete
    }
    
    override func configure(model: Concrete.Model) {
        concrete.configure(model: model)
    }
    
    override var sizeLabelText: String {
        get { return concrete.sizeLabelText }
        set { concrete.sizeLabelText = newValue }
    }
}

final class AnyRow<Model>: Row {
    private let box: _AnyRowBase<Model>
    
    init<Concrete: Row>(_ concrete: Concrete) where Concrete.Model == Model {
        box = _AnyRowBox(concrete)
    }
    
    func configure(model: Model) {
        box.configure(model: model)
    }
    
    var sizeLabelText: String {
        get { return box.sizeLabelText }
        set { box.sizeLabelText = newValue }
    }
}

/* ~~~~~ Playground Action ~~~~~ */

struct Folder {
    let name: String
}
struct File {
    let filename: String
}

class FolderCell: Row {
    typealias Model = Folder
    var sizeLabelText: String = ""
    func configure(model: Folder) {
        print("Configured a \(type(of: self))")
    }
}

class FileCell: Row {
    typealias Model = File
    var sizeLabelText: String = ""
    func configure(model: File) {
        print("Configured a \(type(of: self))")
    }
}

class DetailFileCell: Row {
    typealias Model = File
    var sizeLabelText: String = ""
    func configure(model: File) {
        print("Configured a \(type(of: self))")
    }
}

let cells: [AnyRow<File>] = [
    AnyRow(FileCell()),
    AnyRow(DetailFileCell())
]

cells.map { $0.configure(model: File(filename: "mapped foo")) }
cells.forEach {
    $0.sizeLabelText = "for each'd"
    print($0.sizeLabelText)
}
