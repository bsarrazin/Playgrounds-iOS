import SwiftUI

struct ContentView: View {

    @ObservedObject var order: OrderModel
    @State var isMenuDisplayed: Bool = true

    var body: some View {
        VStack {
            Button {
                isMenuDisplayed.toggle()
            } label: {
                TitleView(title: "Order Pizza", isDisplayingOrder: isMenuDisplayed)
            }

            MenuListView(orderModel: order)
                .layoutPriority(isMenuDisplayed ? 1 : 0.5)

            OrderListView(orderModel: order)
                .layoutPriority(isMenuDisplayed ? 0.5 : 1)
                .animation(.spring())
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(order: .init())
                .environmentObject(UserPreferences())
            ContentView(order: .init())
                .colorScheme(.dark)
                .background(Color.black)
                .environmentObject(UserPreferences())
            ContentView(order: .init())
                .colorScheme(.dark)
                .background(Color.black)
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
                .environmentObject(UserPreferences())
        }
    }
}
