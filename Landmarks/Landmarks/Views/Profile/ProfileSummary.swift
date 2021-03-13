import SwiftUI

struct ProfileSummary: View {

    @EnvironmentObject var modelData: ModelData

    var profile: Profile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(profile.username)
                    .bold()
                    .font(.title)

                Text("Notifications: \(profile.prefersNotifications ? "ON" : "OFF")")
                Text("Seasonal Photo: \(profile.seasonalPhoto.rawValue)")
                Text("Goal Date: ") + Text(profile.goalDate, style: .date)

                Divider()

                VStack(alignment: .leading) {
                    Text("Completed Badges")
                        .font(.headline)

                    ScrollView(.horizontal) {
                        HStack {
                            HikeBadge(name: "First Hike")
                            HikeBadge(name: "Earth Day")
                                .hueRotation(.degrees(90))
                            HikeBadge(name: "Tenth Hike")
                                .grayscale(0.5)
                                .hueRotation(.degrees(45))
                        }
                        .padding(.bottom)
                    }
                }

                Divider()

                VStack(alignment: .leading) {
                    Text("Recent Hikes")
                        .font(.headline)

                    HikeView(hike: modelData.hikes[0])
                }
            }
        }
        .padding()
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: .default)
            .environmentObject(ModelData())
    }
}
