import SwiftUI

struct RatingView: View {

    // MARK: - Bindings
    @Binding var rating: Int

    // MARK: - Properties
    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor: Color = .gray
    var onColor: Color = .yellow

    // MARK: - Body
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { number in
                image(for: number)
                    .foregroundColor(color(for: number))
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }

    // MARK: - Actions
    private func color(for number: Int) -> Color {
        if number > rating {
            return offColor
        } else {
            return onColor
        }
    }
    private func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(
            rating: .constant(4),
            label: "Rating",
            maximumRating: 5,
            offImage: .init(systemName: "star")
        )
    }
}
