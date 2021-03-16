import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ContentView(order: OrderModel())
                .tabItem {
                    Image(systemName: "cart")
                    Text("Order")
                }
            HistoryListView(imageId: .constant(4))
                .tabItem {
                    Image(systemName: "book")
                    Text("History")
                }
        }
        .accentColor(Color("B1"))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(UserPreferences())
    }
}
