
import Foundation


public final class MileusWatchdogLocationSync {
    
    private let locationService: LocationService = CoreLocationService()
    
    public init() throws {
        if !locationService.isAllowed {
            throw MileusWatchdogError.insufficientLocationPermission
        }
    }
    
    public func start(completion: (() -> Void)? = nil) {
        locationService.startUpdating { [weak self] coordinate in
            self?.handleLocationUpdate(coordinate: coordinate)
        }
    }
    
    private func handleLocationUpdate(coordinate: Coordinate) {
        
    }
    
}
