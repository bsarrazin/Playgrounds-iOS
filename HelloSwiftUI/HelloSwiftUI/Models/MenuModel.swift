import Foundation

struct MenuItem: Identifiable {
    var id: Int
    var name: String
    var description: String
    var price: Double
    var rating: Int
}

extension MenuItem {
    static let testItem = MenuItem(
        id: 0,
        name: "Huli Chicken",
        description: "Our original Hawaiian street food pizza, with Huli Huli chicken, onions, ginger, crushed macadamia nuts, tomato sauce, and cheese on a classic crust.",
        price: 14.00,
        rating: 6
    )

}


struct MenuModel {
    var menu: [MenuItem] = [
        MenuItem(id: 1, name: "Margherita", description: "The classic pizza of Buffalo. Mozzarella, tomatoes, and basil on a classic crust.", price: 12.00, rating: 5 ),
        MenuItem(id: 2, name: "Huli Chicken", description: "Our original Hawaiian street food pizza, with huli huli chicken, onions, ginger, crushed macadamia nuts, tomato sauce and cheese on a classic crust.", price: 14.00, rating: 6),
        MenuItem(id: 3, name: "Quattro Formaggi", description: "A blend of Asiago, Parmesan, buffalo mozzarella, and Gorgonzola on a thin crust.", price: 13.00, rating: 5),
        MenuItem(id: 4, name: "Longboard", description: "A very long flatbread for vegetarians and vegans, made with olive oil, mushrooms, garlic, fresh ginger, and macadamias, sweetened with lilikoi.", price: 15.00, rating: 4),
        MenuItem(id: 5, name: "The Big Island", description: "A meaty calzone exploding like a volcano. Beef and pork combined with vegetables, pineapple, and a special \"lava sauce\" leaking out the top crater. Definitely share this one.", price: 17.00, rating: 6),
        MenuItem(id: 6, name: "Pepperoni", description: "The New York Classic version. A thin crust with pizza sauce, cheese, and pepperoni.", price: 10.00, rating: 5),
        MenuItem(id: 7, name: "Chicago Deep Dish", description: "The classic deep dish cheese pizza. 2\"Thick and filled with sauce and cheese. ", price: 17.00, rating: 6),
        MenuItem(id: 8, name: "Meat Lovers", description: "A deep dish for the carnivore. Sausage and pepperoni in the classic Chicago deep dish.", price: 20.00, rating: 4),
        MenuItem(id: 9, name: "BBQ Chicken", description: "Grilled chicken with barbecue sauce, red onions, and peppers.", price: 14.00, rating: 5),
        MenuItem(id: 10, name: "Hawaiian", description: "It may be from the mainland, but we make it our own. Pineapple, SPAM, cheese, onions, and tomato sauce on a thin crust.", price: 14.00, rating: 5)
    ]    
}
