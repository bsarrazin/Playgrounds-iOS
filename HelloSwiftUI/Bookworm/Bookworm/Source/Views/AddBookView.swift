import SwiftUI

struct AddBookView: View {

    // MARK: - Env
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode

    // MARK: - State
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(Array.genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    TextField("Write a review", text: $review)
                }

                Section {
                    RatingView(rating: $rating)
//                    Picker("Rating", selection: $rating) {
//                        ForEach(0..<6) {
//                            Text("\($0)")
//                        }
//                    }
                }

                Section {
                    Button("Save", action: save)
                }
            }
            .navigationBarTitle("Add Book")
        }
    }

    // MARK: - Actions
    private func save() {
        let book = Book(context: context)
        book.title = title
        book.author = author
        book.rating = Int16(rating)
        book.genre = genre
        book.review = review

        try! context.save()
        presentationMode.wrappedValue.dismiss()
    }
}

private extension Array where Element == String {
    static let genres: [String] = [
        "Fantasy",
        "Horror",
        "Kids",
        "Mystery",
        "Poetry",
        "Romance",
        "Thriller"
    ]
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
