import SwiftUI

let staticFont: Font = .system(size: 22)

struct TitleView: View {

    @Environment(\.verticalSizeClass) var verticalSizeClass
    var title: String
    var isDisplayingOrder: Bool! = nil

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(verticalSizeClass != .compact ? .largeTitle : staticFont)
                .fontWeight(.heavy)
                .padding(.trailing)

        }
        .overlay(
            Image(systemName: "chevron.up.square")
                .rotationEffect(isDisplayingOrder ?? false ? Angle(degrees: 0) : Angle(degrees: 180))
                .animation(.easeInOut(duration: 0.5))
                .font(verticalSizeClass != .compact ? .title : staticFont)
                .foregroundColor(isDisplayingOrder != nil ? Color("G1") : .clear)
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
            TitleView(title: "Order Pizza", isDisplayingOrder: true)
                .environment(\.verticalSizeClass, .compact)
        }
    }
}
