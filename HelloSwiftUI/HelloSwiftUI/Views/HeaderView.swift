import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            ZStack {
                Image("Surf Board")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        minWidth: 300,
                        idealWidth: 500,
                        maxWidth: 600,
                        minHeight: 75,
                        idealHeight: 143,
                        maxHeight: 150,
                        alignment: .center
                    )
                Text("Huli Pizza Company")
                    .offset(x: -20, y: 30)
                    .font(.custom("Avenir-Black", fixedSize: 20))
                    .foregroundColor(.white)
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
    }
}
