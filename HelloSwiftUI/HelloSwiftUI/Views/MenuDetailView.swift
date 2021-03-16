import SwiftUI

/// A `View`for entering in an order. Takes basic information about the order from `menuItem`
struct MenuDetailView: View {

    let sizes: [Size] = [.small, .medium, .large]
    @EnvironmentObject var settings: UserPreferences
    @ObservedObject var orderModel: OrderModel
    @State var didOrder: Bool = false
    @State var quantity: Int = 1

    var menuItem: MenuItem
    var formattedPrice: String {
        String(format:"%3.2f", menuItem.price * Double(quantity) * settings.size.rawValue)
    }
    func addItem() {
        didOrder = true
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

            Picker(selection: $settings.size, label: Text("Pizza Size")) {
                ForEach(sizes, id: \.self) { size in
                    Text(size.formatted())
                        .tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            Stepper(value: $quantity, in: 1...10) {
                Text("Quantity: \(quantity)")
                    .bold()
            }

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
                .sheet(isPresented: $didOrder) {
                    ConfirmView(
                        menuID: menuItem.id,
                        orderModel: orderModel,
                        isPresented: $didOrder,
                        quantity: $quantity,
                        size: $settings.size
                    )
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
            .environmentObject(UserPreferences())
    }
}
