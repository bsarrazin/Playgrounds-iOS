import SwiftUI

/// A `View`for entering in an order. Takes basic information about the order from `menuItem`
struct MenuDetailView: View {

    @EnvironmentObject var settings: UserPreferences
    @ObservedObject var orderModel: OrderModel

    var menuItem: MenuItem
    var formattedPrice: String {
        String(format:"%3.2f",menuItem.price)
    }
    func addItem() {
        orderModel.add(menuID: menuItem.id)
    }

    var body: some View {
        VStack {
            TitleView(title: menuItem.name)
            SelectedImageView(name: "\(menuItem.id)_250w")
                .padding(5)
                .layoutPriority(3)
            
            Text(menuItem.description)
                .lineLimit(5)
                .padding()
                .layoutPriority(3)

            Spacer()
            HStack{
                Spacer()
                Text("Pizza size")
                Text(settings.size.formatted())
            }
            .font(.headline)
            HStack{
                Text("Quantity:")
                Text("1")
                    .bold()
                Spacer()
            }
            .padding()
            HStack{
                Text("Order:  \(formattedPrice)")
                    .font(.headline)
                Spacer()
                Text("Order total: \(orderModel.formattedTotal)")
                    .font(.headline)
            }
            .padding()
            HStack{
                Spacer()
                Button(action: addItem) {
                    Text("Add to order")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color("G4"))
                        .foregroundColor(Color("IP"))
                        .cornerRadius(5)
                }
                Spacer()
            }
            .padding(.top)
            Spacer()
        }
        
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailView(orderModel: .init(), menuItem: .testItem)
    }
}
