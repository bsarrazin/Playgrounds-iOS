import SwiftUI

struct ProfileHost: View {

    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @State private var draft = Profile.default

    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            HStack {
                if editMode?.wrappedValue == .inactive {
                    Button("Cancel") {
                        draft = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }

            if editMode?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile)
            } else {
                ProfileEditor(profile: $draft)
                    .onAppear {
                        draft = modelData.profile
                    }
                    .onDisappear {
                        modelData.profile = draft
                    }
            }

        }
        .padding()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(ModelData())
    }
}
