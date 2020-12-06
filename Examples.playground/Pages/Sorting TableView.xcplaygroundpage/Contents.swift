import PlaygroundSupport
import UIKit

extension Array {
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}

class OrderingTableCell: UITableViewCell {
    
    static var id: String { .init(describing: Self.self) }
    static var count: Int = 0 {
        didSet { print("Cell count: \(count)") }
    }
    
    private(set) var label: UILabel!
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        Self.count += 1
        
        label = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

class TableViewController: UITableViewController {
    
    private var items = [
        "A", "B", "C",
        "D", "E", "F",
        "G", "H", "I",
        // "J", "K", "L",
        // "M", "N", "O",
        // "P", "Q", "R",
        // "S", "T", "U",
        // "V", "W", "X",
        // "Y", "Z",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Use the handles to sort"
        tableView.register(OrderingTableCell.self, forCellReuseIdentifier: OrderingTableCell.id)
        tableView.reloadData()
        tableView.isEditing = true
        tableView.tableFooterView = .init()
        
        print("Item count: \(items.count)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderingTableCell.id, for: indexPath) as! OrderingTableCell
        cell.label?.text = "\(indexPath.row). " + items[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        items.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

let vc = TableViewController()
let nav = UINavigationController(rootViewController: vc)
nav.view.bounds = .init(x: 0, y: 0, width: 320, height: 480)
PlaygroundPage.current.liveView = nav
