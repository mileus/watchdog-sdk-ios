
import Foundation
import CoreLocation


protocol LocationService {
    var isAllowed: Bool { get }
}


final class CoreLocationService: LocationService {
    
    private let allowedPermissions = Set<CLAuthorizationStatus>([.authorizedAlways, .authorizedWhenInUse])
    
    var isAllowed: Bool {
        allowedPermissions.contains(CLLocationManager.authorizationStatus())
    }
    
}
