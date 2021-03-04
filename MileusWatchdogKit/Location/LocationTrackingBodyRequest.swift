
import Foundation


struct LocationTrackingBodyRequest: BodyRequest {
    let location: LocationTrackingLocation
}

struct LocationTrackingLocation: Encodable {
    let coordinates: LocationTrackingCoordinates
    let accuracy: Int
}

struct LocationTrackingCoordinates: Encodable {
    let lat: Double
    let lon: Double
}
