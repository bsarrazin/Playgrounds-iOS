import SwiftUI

struct HistoryListItemView: View {

    var item: HistoryItem

    var body: some View {
        HStack(alignment: .top) {
            Image("\(item.id)_100w")
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
            Text(item.name)
                .font(.title)
            Spacer()
        }
        .overlay(
            Image(systemName: "chevron.right.square")
                .padding()
                .font(.title)
                .foregroundColor(Color("G3")),
            alignment: .trailing
        )
    }
}

struct HistoryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListItemView(item: HistoryModel().historyItems[0])
    }
}
