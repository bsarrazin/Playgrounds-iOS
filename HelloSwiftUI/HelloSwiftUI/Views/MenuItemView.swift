import SwiftUI

struct MenuItemView: View {

    var item: MenuItem = .testItem

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 15) {
                Image("\(item.id)_100w")
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)

                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.title)
                        .fontWeight(.light)
                    RatingView(count: item.rating)
                }
            }
            Text(item.description)
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MenuItemView()
            MenuItemView(item: MenuModel().menu[0])
            MenuItemView(item: MenuModel().menu[1])
            MenuItemView(item: MenuModel().menu[8])
            MenuItemView().environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        }
    }
}
