import SwiftUI

struct MyView: View {

    @AppStorage("foo") var foo: Bool = false

    var body: some View {
        Button {
            foo.toggle()
        } label: {
            Text(foo ? "true" : "false")
        }
    }
}

import PlaygroundSupport
PlaygroundPage.current.liveView = UIHostingController(rootView: MyView())
