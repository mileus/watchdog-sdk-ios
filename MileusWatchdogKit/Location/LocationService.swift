
import Foundation
import CoreLocation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

protocol LocationService {
    
    typealias UpdateHandler = (Coordinate, Double) -> Void
    
    var isAllowed: Bool { get }
    
    func startUpdating(update: @escaping UpdateHandler)
    func stopUpdating()
}


final class CoreLocationService: NSObject, LocationService {
    
    private let allowedPermissions = Set<CLAuthorizationStatus>([.authorizedAlways, .authorizedWhenInUse])
    private let locationManager = CLLocationManager()
    
    private var updateCallback: UpdateHandler?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    var isAllowed: Bool {
        allowedPermissions.contains(CLLocationManager.authorizationStatus())
    }
    
    func startUpdating(update: @escaping UpdateHandler) {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension CoreLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        updateCallback?(
            .init(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            ),
            location.horizontalAccuracy
        )
    }
}
