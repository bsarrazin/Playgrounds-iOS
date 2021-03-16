import SwiftUI

struct TitleView: View {

    var title: String
    var isDisplayingOrder: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.trailing)

        }.overlay(
            Image(systemName: isDisplayingOrder ? "chevron.up.square" : "chevron.down.square")
                .font(.title)
                .padding(),
            alignment: .leading
        )
        .background(Color("G4"))
        .foregroundColor(Color("G1"))
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TitleView(title: "Order Pizza", isDisplayingOrder: false)
            TitleView(title: "Order Pizza", isDisplayingOrder: true)
        }
    }
}
