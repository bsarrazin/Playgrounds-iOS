import SwiftUI


var size: Size = .medium

struct MenuDetailView: View {

    @EnvironmentObject var settings: UserPreferences
    @ObservedObject var orderModel: OrderModel
    @State var didOrder: Bool = false
    @State var quantity: Int = 1
    var menuItem: MenuItem
    var formattedPrice: String {
        String(format:"%3.2f", menuItem.price * Double(quantity) * size.rawValue)
    }
    func addItem() {
        didOrder = true
    }

    func isCompactPortrait(proxy: GeometryProxy) -> Bool {
        return proxy.size.height <= 414
    }

    func titleView() -> some View {
        GeometryReader { proxy in
            HStack{
                SelectedImageView(name: "\(menuItem.id)_250w")
                    .padding(5)
                Text(self.menuItem.description)
                    .frame(width: proxy.size.width * 2/5)
                    .font(proxy.size.height > 200 ? .body : .caption)
                    .padding()
                Spacer()
            }
        }
    }

    func menuOptionsView() -> some View {
       VStack {
            SizePickerView(size: $settings.size)
            QuantityStepperView(quantity: $quantity)
            TitleView(title: "Order: \(formattedPrice)")
            Spacer()
        }
    }

    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack{
                    TitleView(title: menuItem.name)
                    Button(action: addItem) {
                        Text("Add to order")
                            .font(isCompactPortrait(proxy: proxy) ? staticFont : .title)
                            .fontWeight(.bold)
                            .padding([.leading, .trailing])
                            .background(Color("G3"))
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
                }

                if isCompactPortrait(proxy: proxy) {
                    HStack{
                        titleView()
                        menuOptionsView()
                    }
                } else {
                    VStack{
                        titleView()
                        menuOptionsView()
                    }
                }
            }
            .padding(.top, 5)
        }
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailView(orderModel: OrderModel(), menuItem: .testItem)
    }
}

struct QuantityStepperView: View {
    @Binding var quantity: Int
    var body: some View {
        Stepper(value: $quantity, in: 1...10) {
            Text("Quantity \(quantity)")
        }
        .padding()
    }
}

struct SizePickerView: View {

    @Binding var size: Size
    let sizes: [Size] = [.small, .medium, .large]
    var body: some View {
        Picker(selection: $size, label: Text("Pizza Size")) {
            ForEach(sizes, id:\.self) { size in
                Text(size.formatted()).tag(size)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .font(.headline)
    }
}
