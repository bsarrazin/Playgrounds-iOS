import SwiftUI

struct RootView: View {

    @Binding var scrums: [DailyScrum]

    var body: some View {
        ScrumsView(scrums: $scrums)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RootView(scrums: .constant(DailyScrum.data))
        }
    }
}
