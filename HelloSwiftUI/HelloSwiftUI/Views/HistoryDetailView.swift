import SwiftUI

struct HistoryDetailView: View {
    var historyItem: HistoryItem
    @Binding var imageID: Int
    @State var isPresented: Bool = false

    var body: some View {
        imageID = historyItem.id
        return VStack {
            TitleView(title: historyItem.name)
            MapView(lat: historyItem.latitude, long: historyItem.longitude, radius: 1_000_000)
                .frame(height: 100)

            PresentMapButton(isPresented: $isPresented, historyItem: historyItem)

            Text(historyItem.history)
                .frame(height:300)
            Spacer()
        }
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetailView(historyItem:HistoryModel().historyItems[6], imageID: .constant(0))
    }
}
