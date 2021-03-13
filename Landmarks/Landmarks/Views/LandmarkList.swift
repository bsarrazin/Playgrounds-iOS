import SwiftUI

struct LandmarkList: View {

    @EnvironmentObject var modelData: ModelData
    @State private var showFavouritesOnly = false

    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { !showFavouritesOnly || $0.isFavorite }
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavouritesOnly) {
                    Text("Favorites Only")
                }
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink(destination: LandmarkDetails(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var devices: [Device] = [
        .iPhoneSE, .iPhoneXSMax
    ]
    static var previews: some View {
        ForEach(devices.map(\.name), id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(.init(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .environmentObject(ModelData())
        }

    }
}

struct Device {
    var name: String
}

extension Device {
    static let iPhoneSE: Self = .init(name: "iPhone SE")
    static let iPhoneXSMax: Self = .init(name: "iPhone XS Max")
}
