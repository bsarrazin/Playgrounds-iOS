import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {

    var lat: Double
    var long: Double
    var radius: Double

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        view.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.addAnnotation(annotation)
    }
}

// struct MapView_Previews: PreviewProvider {
//     static var previews: some View {
//         MapView()
//     }
// }
