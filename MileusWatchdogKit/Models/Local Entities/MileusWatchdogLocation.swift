
import Foundation


public struct MileusWatchdogLocation {
    
    public let address: MileusWatchdogAddress?
    public let latitude: Double
    public let longitude: Double
    public let accuracy: Float
    
    public init(address: MileusWatchdogAddress?, latitude: Double, longitude: Double, accuracy: Float = 0.0) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
    }
    
}
