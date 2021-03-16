import Foundation

struct HistoryItem: Codable, Identifiable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var history: String
}
struct PizzaHistoryItems: Codable {
    var items: [HistoryItem] = []
}

class HistoryModel {
    private var items = PizzaHistoryItems()
    var historyItems: [HistoryItem] { items.items }
    init() {
        loadData()
    }
    func loadData() {
        do {
            try items = JSONDecoder().decode(PizzaHistoryItems.self, from: data)
        } catch {
            print("Error reading JSON file: \(error.localizedDescription)")
        }
    }
}


let data = """
{"items":[
    {"id":0,"name":"Margherita","latitude":40.8371,"longitude":14.2467,"history":"Street Food Nationalized - The legend goes that King Umberto and Queen Margherita of Italy got tired of the royal food, which was always French. Looking for both something new and something Italian, while in Naples they ordered a local pizzeria to make them pizza, which was up until then considered a food for the poor. The Queen loved a pizza of tomatoes, fresh mozzarella, and basil so much the restaurant named the pizza after her. That the pizza was the colors of the Italian flag may not be a coincidence. To this day, to sell a true Neapolitan pizza, you must be certified by an association of pizza restaurants in Naples for the process and for the quality of ingredients."},
    {"id":1,"name":"Huli Chicken","latitude":40.7217,"longitude":-73.9956,"history":"In a completely fictitious Hawaii, on the island of Oahu, some friends got together to make pizzas, island style. They were often hungry after a good wave or two and wanted somewhere good to go that didn't look and taste mainland, especially Canadian. They took street foods and traditional pizzas from around the world to create a new pizza experience. In Hawaiian, hull means turn, which is a reference to the manual barbecue and rotisserie method of cooking huli chicken in teriyaki sauce blends."},
    {"id":2,"name":"Quattro Formaggi","latitude":41.8982864,"longitude":12.470432,"history":"With the respectability of the Margherita pizza, other varieties began to spring up all over Italy. One common favorite is a quattro formaggi, a blend of melted cheeses. The best cheeses are often found in Rome, since the Neapolitans don't think it's authentic enough for them. "},
    {"id":3,"name":"Long Board","latitude":32.2300325,"longitude":37.2087672,"history":"Eating other food items on top of flatbread goes back to ancient times, with evidence of flatbread being made as far at 14,000 years ago in what today is northeastern Jordan. There are Biblical mentions in Exodus and Leviticus. Roman soldiers, during the time of Caesar, stationed in the Middle East probably brought this food technique home with them. The Aramaic word for bread, which usually was flat, is pita. That may have gotten Romanized first to pisa and then pizza."},
    {"id":4,"name":"Big Island","latitude":40.7316751,"longitude":40.7316751,"history":"Calzones started in Naples as smaller pizzas you could eat while walking since, in Italy, they didn't serve slices, but rather, whole pizzas. In the early 20th century, John Sasso, of John's of Bleeker street in New York, started making huge sharable calzones you could only eat at the table."},
    {"id":5,"name":"Pepperoni","latitude":40.7217,"longitude":-73.9956,"history":"The first known pizza restaurant in the United States was in New York’s region known as Little Italy. In 1905, Gennaro Lombardi opened his restaurant, but used a coal oven instead of a wood-burning one, since coal was cheaper than wood in New York. New York pizza breaks several traditions from its Italian ancestor. Most importantly, it is sold in large slices, which meant whole pizzas were made larger than the traditional 14 inch (35cm) diameter. To make a larger pizza, a  higher gluten recipe is used for the crust, and the pizza is tossed in the air with a spinning motion. Italian New Yorkers are probably the first to add pepperoni, a sausage created from American ingredients. "},
    {"id":6,"name":"Meat Lovers","latitude":37.7210483,"longitude":-97.2866428,"history":"The Meat Lover's pizza was the advertising brainchild of one of the first international pizza Chains, Pizza Hut. Stared in Wichita Kansas in 1958,  Brothers Dan and Fran Carney went on to build an empire, later to be sold off to Pepsi. When the original Pizza Hut was to be demolished for an expressway, the building was moved to the campus of Wichita State University."},
    {"id":7,"name":"Chicago Deep Dish","latitude":41.8937,"longitude":-87.6276,"history":"In 1943, Ike Sewell changed the crust from the thin flatbread to a deep pan, adding traditional Italian and New York ingredients. Sewell and his cook, and eventual manager, Rudy Malnati added a layer of sausage to the pan. Some believe the longer cooking time of 20 to 45 minutes of the deep dish meant more beverage consumption, and a higher profit for the restaurant. Deep dish pizza caught on in Chicago, with many competitors in the area. With the 2 inches of deeper pizza crust, the order of ingredients can change between competitors, with a crust ranging in texture from cracker-like to bread-like, and the cheese on top or on the sauce on top."},
    {"id":8,"name":"BBQ Chicken","latitude":34.0646,"longitude":-118.3993,"history":"Two Los Angeles Attorneys, Larry Flax and Rick Rosenfeld, were so entranced by Spago's pizza chef Ed LaDou’s pizzas that they started a casual dining restaurant with some of LaDou’s creations, including a new one of barbecue sauce and chicken. The restaurant was so successful, it became a chain throughout North America, South America, and Asia, popularizing non-Italian and often Asian, ingredients in pizza. A national food of Italy becomes a uniquely American food all over the world. Suspiciously, there are no locations in Europe."},
    {"id":9,"name":"Hawaiian","latitude":42.4062,"longitude":-82.1861,"history":"The so-called Hawaiian pizza is not Hawaiian: it's a Canadian treasure. Greek immigrant to Canada, Sam Panopoulos added canned pineapple and Canadian bacon to a pizza in his small restaurant in Ontario, Canada. This is the one of the earliest pizzas without traditional Italian ingredients. As late as 2017, a few months before the death of Panopoulos, this was controversial, with purists angry about pineapple on a pizza. Iceland’s president started a near diplomatic incident between Canada and Iceland with a statement that he would make pineapple on pizza illegal if he had the power to."}
]}
""".data(using: .utf8)!
