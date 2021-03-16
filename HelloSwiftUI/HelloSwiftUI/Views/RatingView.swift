import SwiftUI

struct RatingView: View {

    var count: Int = 5
    var rating: [String] {
        let symbol = "\(count).circle"
        return .init(repeating: symbol, count: count)
    }

    var body: some View {
        HStack {
            ForEach(rating, id: \.self) { item in
                Image(systemName: item)
                    .font(.headline)
                    .foregroundColor(Color("G4"))
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
