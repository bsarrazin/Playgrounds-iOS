import Combine
import Foundation

///  A type for size of pizzas with a mutiplier to the price as a raw value.
enum Size: Double {
    case small = 1.0
    case medium = 1.25
    case large = 1.50
    
    /// a formatted string version of the size
    func formatted() -> String {
        let sizeString: String
        switch self {
        case .small: sizeString = "Small"
        case .medium: sizeString = "Medium"
        case .large: sizeString = "Large"
        }
        return sizeString
    }
}

/// The basic record for each item ordeed.
struct OrderItem: Identifiable {
    var id: Int
    var menuID: Int
    var name: String
    var comments: String = ""
    var price: Double
    var size: Size = .small
    var quantity: Int = 1
    
    ///Extended price for the pizza order, using the size multiplier and the quantity.
    var extendedPrice: Double {
        price * Double(quantity) * size.rawValue
    }
    /// A `String` of the extended price
    var formattedExtendedPrice: String {
        String(format:"$%3.2f",extendedPrice)
    }
    /// A `String` describing an order
    var description: String {
        return "\(quantity) " + size.formatted() + " " + name
    }
}

/// The Model for holding an order
class OrderModel: ObservableObject {
    let menu = MenuModel()
    @Published var orders: [OrderItem] = []
    var lastID: Int = -1
    
    /// Creates a newID based on the last known ID
    private func newId() -> Int {
        lastID += 1
        return lastID
    }
    
    ///Returns the total extended price
    var total: Double {
        var total = 0.0
        for item in orders {
            total += item.extendedPrice
        }
        return total
    }
    
    ///Returns the last name in the order list
    var lastOrderName: String {
        orders.last?.name ?? "Nil!"
    }
    
    ///Returns the last `orderID`. If not found, gives -1
    var lastOrderID: Int {
        orders.last?.id ?? -1
    }
    
    /// Returns total as a string in $0.00 format
    var formattedTotal: String {
        String(format: "$%3.2f", total)
    }
    
    
    /// Returns the menu item for a given menu ID
    /// - Parameter menuID: an `Int` that identifies a unique menu item.
    func menu(_ menuID: Int) -> MenuItem! {
        return menu.menu.first { item in
            item.id == menuID
        }
    }
    
    /// Add a item to the order by orderitem name.
    /// - Parameter orderItem: An Id from the menu model. required.
    /// - Parameter size: A size of pizza. Defaults to **small**
    /// - Parameter quantity: Number of items ordered. Defaults to **1**
    /// - Parameter comments: Comments and special instructions from user.
    func add(menuID: Int, size: Size = .small, quantity: Int = 1, comments: String = "") {
        guard let orderedItem:MenuItem = menu(menuID) else {
            return print("Item #\(menuID) not found" )
        }
        let order = OrderItem(id: newId(), menuID: menuID, name: orderedItem.name, comments: comments, price: orderedItem.price, size: size, quantity: quantity)
        orders += [order]
    }
    
    /// Three items added for testing. Remove for functional use.
    init(){
        add(menuID: 1)
        add(menuID: 0)
        add(menuID: 6)
    }
    
}

/// A test copy of the OrderModel
let testOrderModel = OrderModel()
/// A test copy of the OrderItem()
let testOrderItem = OrderItem(id: 1, menuID: 1, name: "Huli Chicken", comments: "Add more macadamias!", price: 9.99, size: .medium, quantity: 1)


///An class for user preferences in ordering. Will be used with an environment object.
class UserPreferences: ObservableObject {
    @Published var size: Size = .medium
}

