import MapKit
import UIKit

class MapViewController: UIViewController {

    var latitude: CLLocationDegrees = 40.8371
    var longitude: CLLocationDegrees = 14.2467
    var regionRadius: CLLocationDistance = 1000000
    private let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()


        view.addSubview(mapView)
        mapView.frame = view.bounds

        updateMap()
    }

    func updateMap() {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}
