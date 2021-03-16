import SwiftUI

struct HistoryListView: View {

    var model: HistoryModel = .init()
    @Binding var imageId: Int

    var body: some View {
        VStack {
            TitleView(title: "Pizza History")
            SelectedImageView(name: "\(imageId)_250w")
                .padding()

            NavigationView {
                List(model.historyItems) { item in
                    NavigationLink(destination: HistoryDetailView(historyItem: item, imageID: $imageId)) {
                        HistoryListItemView(item: item)
                    }
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HistoryListView(imageId: .constant(3))
        }
    }
}
