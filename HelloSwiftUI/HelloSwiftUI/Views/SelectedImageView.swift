import SwiftUI

struct SelectedImageView: View {

    var name: String

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .cornerRadius(30)
            .shadow(color: .black, radius: 10, x: 5, y: 5)
    }
}

struct SelectedImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedImageView(name: "1_250w")
    }
}
