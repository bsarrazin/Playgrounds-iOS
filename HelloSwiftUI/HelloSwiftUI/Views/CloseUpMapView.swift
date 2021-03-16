import SwiftUI
import MapKit

/// A view to present a view controller and add a Swift UI title and dismiss button.
struct CloseUpMapView: View {

    @Binding var isMapPresented: Bool
    var item: HistoryItem

    var body: some View {
        VStack{
            TitleView(title: item.name)
            MapViewControllerWrapper(latitude: item.latitude, longitude: item.longitude, regionRadius: 100)
            DismissButton(isPresented: $isMapPresented)
        }
    }
}


/// A generic button to dismiss a view. Changes `$isPresented` to `false` when tapped.
struct DismissButton: View {
    @Binding var isPresented: Bool
    var body: some View {
        Button {
            isPresented = false
        } label: {
            Text("Dismiss")
                .padding()
                .background(Color("G2"))
                .foregroundColor(.primary)
                .cornerRadius(5)
        }
    }
}

///Presents the `CloseUpMapView` as a sheet if tapped. Send a `historyItem` in it to get a location.
struct PresentMapButton: View {
    @Binding var isPresented: Bool
    var historyItem: HistoryItem

    var body: some View {
        Button {
            isPresented = true
        } label: {
            HStack{
                Image(systemName:"chevron.up.square")
                Text("Detail Map")
                    .fontWeight(.heavy)
                    .padding(10)
            }
            .padding(.leading)
            .background(Color("G3"))
        }
        .sheet(isPresented: $isPresented) {
            CloseUpMapView(isMapPresented: $isPresented, item: historyItem)
        }
    }
}

struct MapViewControllerWrapper: UIViewControllerRepresentable {

    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var regionRadius: CLLocationDistance
    
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MapViewControllerWrapper>) -> MapViewControllerWrapper.UIViewControllerType {
         return MapViewController()
    }
    
    func updateUIViewController(_ vc: MapViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<MapViewControllerWrapper>) {
        vc.latitude = latitude
        vc.longitude = longitude
        vc.regionRadius = regionRadius
        vc.updateMap()
    }
}
