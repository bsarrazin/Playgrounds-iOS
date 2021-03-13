import SwiftUI

struct FavoriteButton: View {

    @Binding var isSet: Bool

    var body: some View {
        Button(
            action: { isSet.toggle() },
            label: { Image(systemName: isSet ? "star.fill" : "star") }
        )
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true))
    }
}
