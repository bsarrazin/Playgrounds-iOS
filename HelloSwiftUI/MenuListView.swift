import SwiftUI

struct MenuListView: View {

    @ObservedObject var orderModel: OrderModel
    var menu = MenuModel().menu

    var body: some View {
        VStack {
            ListHeaderView(orderModel: orderModel, title: "Menu")
            NavigationView {
                List(menu) { item in
                    NavigationLink(destination: MenuDetailView(orderModel: orderModel, menuItem: item)) {
                        MenuItemView(item: item)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .navigationBarTitle("Pizza Order")
            }
        }
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuListView(orderModel: .init())
    }
}
