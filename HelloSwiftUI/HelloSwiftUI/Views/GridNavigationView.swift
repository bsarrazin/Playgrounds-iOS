import SwiftUI

struct GridNavigationView: View {

    @ObservedObject var orderModel: OrderModel
    var menuList = MenuModel().menu
    let cols: [GridItem] = .init(repeating: .init(spacing: 5), count: 2)
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(menuList) { item in
                    HStack(alignment: .top) {
                        VStack(alignment: .trailing) {
                            Image("Surf Board")
                                .resizable()
                                .scaledToFit()
                                .padding(.bottom, 10)
                            Text(item.name)
                                .font(.headline)
                        }
                        .frame(width:100)

                        // VStack {
                        LazyVGrid(columns: cols, spacing: 5) {
                            if let children = item.children {
                                ForEach(children) { child in
                                    NavigationLink(destination: MenuDetailView(orderModel: orderModel, menuItem: child)) {
                                        VStack {
                                            Image("\(child.id)_100w")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    Divider()
                }
                Spacer()
            }
        }
    }
}

struct GridNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        GridNavigationView(orderModel: testOrderModel)
    }
}
