
import Foundation


final class LocationServiceThrottlingDecorator: LocationService {
    
    private static let throttleLimitMilliseconds = 50.0
    
    var isAllowed: Bool {
        decoratee.isAllowed
    }
    
    private let decoratee: LocationService
    
    private var lastUpdate = Date()
    
    init(decoratee: LocationService) {
        self.decoratee = decoratee
    }
    
    func startUpdating(update: @escaping UpdateHandler) {
        decoratee.startUpdating { [weak self] (coordinates, accuracy) in
            guard let self = self else { return }
            if self.canUpdate() {
                self.updateLastUpdateDate()
                update(coordinates, accuracy)
            }
        }
    }
    
    func stopUpdating() {
        decoratee.stopUpdating()
    }
    
    private func canUpdate() -> Bool {
        let delta = Date().timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
        return delta * 1000.0 > Self.throttleLimitMilliseconds
    }
    
    private func updateLastUpdateDate() {
        lastUpdate = Date()
    }
    
}
