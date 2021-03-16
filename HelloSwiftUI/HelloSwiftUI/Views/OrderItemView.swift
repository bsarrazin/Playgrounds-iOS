import SwiftUI

struct OrderItemView: View {

    var orderItem: OrderItem

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(orderItem.description)
                    .font(.headline)
                Spacer()
                Text(orderItem.formattedExtendedPrice)
                    .bold()
            }
        }
    }
}

struct OrderItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemView(orderItem: testOrderItem)
            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
    }
}
