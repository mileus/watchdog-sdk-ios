
import Foundation


struct LocationTrackingEndpoint: Endpoint {
    
    let baseUrl: String
    let path = "watchdog/v1/search/location-tracking"
    
    let method = HTTPMethod.post
    
    let body: Data?
    
    let token: String
    
    var headers: [String : String]? {
        [
            "Authorization: " : "Bearer \(token)"
        ]
    }
    
}
