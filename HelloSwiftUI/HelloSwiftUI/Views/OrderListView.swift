import SwiftUI

struct OrderListView: View {

    @ObservedObject var orderModel: OrderModel

    var body: some View {
        VStack {
            ListHeaderView(orderModel: orderModel, title: "Your Order")
            List(orderModel.orders) { item in
                OrderItemView(orderItem: item)
            }
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView(orderModel: .init())
    }
}
