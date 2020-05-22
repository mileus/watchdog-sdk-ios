
import Foundation


public struct MileusWatchdogLocation {
    
    public let address: String
    public let latitude: Double
    public let longitude: Double
    public let accuracy: Float
    
    public init(address: String, latitude: Double, longitude: Double, accuracy: Float = 0.0) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
    }
    
}
