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

class TextTableCell: UITableViewCell, SelfIdentifiable {
    
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

protocol SelfIdentifiable {
    static var id: String { get }
}

extension SelfIdentifiable {
    static var id: String { .init(describing: Self.self) }
}

class StepperTableCell: UITableViewCell, SelfIdentifiable {

    private(set) var label: UILabel!
    private(set) var buttonUp: UIButton!
    private(set) var buttonDown: UIButton!

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        label = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        buttonUp = UIButton(type: .system)
        buttonUp.translatesAutoresizingMaskIntoConstraints = false
        buttonUp.setTitle("Up", for: .normal)
        buttonUp.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(buttonUp)

        buttonDown = UIButton(type: .system)
        buttonDown.translatesAutoresizingMaskIntoConstraints = false
        buttonDown.setTitle("Down", for: .normal)
        buttonDown.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(buttonDown)

        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 50),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: buttonDown.leadingAnchor),
            buttonDown.heightAnchor.constraint(equalTo: label.heightAnchor),
            buttonDown.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonDown.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonDown.trailingAnchor.constraint(equalTo: buttonUp.leadingAnchor, constant: -20),
            buttonUp.heightAnchor.constraint(equalTo: label.heightAnchor),
            buttonUp.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonUp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonUp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }

    @objc func buttonTapped(_ sender: UIButton) {
        moveTableCell(self, direction: sender == buttonDown ? .down : .up)
    }
}

@objc enum Direction: Int {
    case down = 0
    case up
}

extension UIResponder {
    @objc func moveTableCell(_ tableCell: UITableViewCell, direction: Direction) {
        guard let next = next else { return print("⚠️ No implementation of \(#function)") }
        next.moveTableCell(tableCell, direction: direction)
    }
}


class TableViewController: UITableViewController {

    // typealias TableCell = TextTableCell
    typealias TableCell = StepperTableCell

    private var items = [
        "A", "B", "C",
        "D", "E", "F",
        "G", "H", "I",
        "J", "K", "L",
        "M", "N", "O",
        // "P", "Q", "R",
        // "S", "T", "U",
        // "V", "W", "X",
        // "Y", "Z",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Use the handles to sort"
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.id)
        tableView.reloadData()
        // tableView.isEditing = true
        tableView.tableFooterView = .init()
        
        print("Item count: \(items.count)")

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.tableView.flashScrollIndicators()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.id, for: indexPath) as! TableCell
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

    override func moveTableCell(_ tableCell: UITableViewCell, direction: Direction) {
        guard let indexPath = tableView.indexPath(for: tableCell) else { return }

        if indexPath.row == 0, direction == .up { return }
        if indexPath.row == items.count - 1, direction == .down { return }

        let destination: IndexPath
        switch direction {
        case .down: destination = .init(row: indexPath.row + 1, section: 0)
        case .up: destination = .init(row: indexPath.row - 1, section: 0)
        }
        tableView.moveRow(at: indexPath, to: destination)
    }
}

let vc = TableViewController()
let nav = UINavigationController(rootViewController: vc)
nav.view.bounds = .init(x: 0, y: 0, width: 320, height: 480)
PlaygroundPage.current.liveView = nav
