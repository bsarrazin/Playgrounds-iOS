import SwiftUI

struct PushButton: View {

    // MARK: - Properties
    let title: String
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    // MARK: - State
    @Binding var isOn: Bool

    // MARK: - Body
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct ContentView: View {

    // MARK: - Env
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>

    // MARK: - State
    @State private var isPresentingAddBook = false

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailsView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)

                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title").font(.headline)
                            Text(book.author ?? "Unknown Author").foregroundColor(.secondary)
                        }
                    }
                }
            }

            .navigationBarTitle("Bookworm")
            .navigationBarItems(
                trailing:
                    Button(action: presentAddBook) {
                        Image(systemName: "plus")
                    }
                    .padding()
            )
            .sheet(
                isPresented: $isPresentingAddBook,
                content: {
                    AddBookView()
                        .environment(\.managedObjectContext, context)
                }
            )
        }
    }

    // MARK: - Actions
    private func presentAddBook() {
        isPresentingAddBook.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
