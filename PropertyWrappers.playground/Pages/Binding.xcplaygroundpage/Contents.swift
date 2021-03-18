import SwiftUI

struct ContentView: View {

    @Binding var bool: Bool

    var body: some View {
        VStack {
            Text(bool ? "true" : "false")
            Button {
                bool.toggle()
            } label: {
                Text("Toggle")
            }
        }
        .background(Color.red)
    }
}

struct RootView: View {

    @State var bool: Bool = false
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            Text(bool ? "true" : "false")
                .sheet(isPresented: $isPresented) {
                    ContentView(bool: $bool)
                }
        }
    }
}

import PlaygroundSupport
PlaygroundPage.current.liveView = UIHostingController(rootView: RootView())
