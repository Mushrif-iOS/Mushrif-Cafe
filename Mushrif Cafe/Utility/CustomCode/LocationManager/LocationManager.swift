import Foundation
import CoreLocation

final class LocationManager: NSObject {
   
    let cafeLatitude = 29.273059471621497
    let cafeLongitude = 48.04890431762706

    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    // MARK: - Public Closure
    var onLocationReceived: ((CLLocation?) -> Void)?
    var onLocationDenied: (() -> Void)?
    var onError: ((Error) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    /// Request location only once (fires `onLocationReceived` or error/denied)
    func requestSingleLocation() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            UDManager.isLocationServiceEnabled = false
            onLocationDenied?()

        @unknown default:
            UDManager.isLocationServiceEnabled = false
            onLocationDenied?()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        } else if status == .restricted || status == .denied {
            UDManager.isLocationServiceEnabled = false
            onLocationDenied?()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }

        // Stop further updates after getting the location once
        manager.stopUpdatingLocation()

        let location = CLLocation(latitude: cafeLatitude, longitude: cafeLongitude) // test

        currentLocation = location
        UDManager.isLocationServiceEnabled = true

        // Perform your one-time task
        onLocationReceived?(location)

        // Optional: clear callback to avoid multiple triggers
        onLocationReceived = nil
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onError?(error)
    }
    
    
}
