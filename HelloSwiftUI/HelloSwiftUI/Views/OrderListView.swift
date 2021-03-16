import SwiftUI

struct OrderListView: View {

    @ObservedObject var orderModel: OrderModel

    var body: some View {
        VStack {
            ListHeaderView(orderModel: orderModel, title: "Your Order")
            List {
                Section(header: ListHeaderView(orderModel: orderModel, title: "Your Order")) {
                    ForEach(orderModel.orders) { item in
                        OrderItemView(orderItem: item)
                    }
                    .onDelete(perform: delete)
                }
            }
        }
    }

    func delete(at offsets: IndexSet) {
        orderModel.orders.remove(atOffsets: offsets)
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView(orderModel: .init())
    }
}
