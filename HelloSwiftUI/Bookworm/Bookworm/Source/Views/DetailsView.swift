import SwiftUI

struct DetailsView: View {

    // MARK: - Property
    var book: Book

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width, minHeight: geo.size.width * 2 / 3)
                        .background(Color.red)

                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }

                Text(book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(book.review ?? "")
                    .padding()

                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)

                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Title"), displayMode: .inline)
    }
}

import CoreData
struct DetailsView_Previews: PreviewProvider {
    static let context: NSManagedObjectContext = .init(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: context)
        book.title = "Some Title"
        book.author = "Me"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is a great book!"

        return DetailsView(book: book)
    }
}
