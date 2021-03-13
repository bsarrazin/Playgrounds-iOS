import SwiftUI

@main
struct App: SwiftUI.App {

    @State private var scrums = DailyScrum.data

    var body: some Scene {
        WindowGroup {
            NavigationView {
                RootView(scrums: $scrums)
            }
        }
    }
}
