
import Foundation


public final class MileusWatchdogLocationSync {
    
    private enum ResponseCode: Int {
        case completed = 200
        case notEnough = 202
    }
    
    public typealias CompletionHandler = () -> Void
    
    private let locationService: LocationService = CoreLocationService()
    private let networkingClient: NetworkingClient = HTTPClient()
    
    private var completionCallback: CompletionHandler?
    
    public init() throws {
        if !locationService.isAllowed {
            throw MileusWatchdogError.insufficientLocationPermission
        }
    }
    
    public func start(completion: CompletionHandler? = nil) {
        self.completionCallback = completion
        locationService.startUpdating { [weak self] coordinate, accuracy in
            self?.handleLocationUpdate(coordinate: coordinate, accuracy: accuracy)
        }
    }
    
    public func stop() {
        callCompletionCallbackAndStopLocationService()
    }
    
    private func handleLocationUpdate(coordinate: Coordinate, accuracy: Double) {
        let location = LocationTrackingLocation(
            coordinates: LocationTrackingCoordinates(lat: coordinate.latitude, lon: coordinate.longitude),
            accuracy: Int(accuracy)
        )
        let endpoint = LocationTrackingEndpoint(
            baseUrl: MileusWatchdogKit.environment.apiURL,
            body: LocationTrackingBodyRequest(location: location).asData(),
            token: MileusWatchdogKit.accessToken
        )
        networkingClient.request(endpoint: endpoint) { [weak self] result in
            self?.handleNetworkResponse(result: result)
        }
    }
    
    private func handleNetworkResponse(result: NetworkingClient.RequestResponse) {
        switch result {
        case let .success((data, response)):
            handleSuccessfulResponse(data: data, response: response)
        case .failure:
            handleFailure()
        }
    }
    
    private func handleSuccessfulResponse(data: Data, response: HTTPURLResponse) {
        if response.statusCode == ResponseCode.completed.rawValue {
            handleSuccess()
        } else if response.statusCode >= 300 {
            stopLocationService()
        }
    }
    
    private func handleSuccess() {
        callCompletionCallbackAndStopLocationService()
    }
    
    private func handleFailure() {
        callCompletionCallbackAndStopLocationService()
    }
    
    private func callCompletionCallbackAndStopLocationService() {
        completionCallback?()
        stopLocationService()
    }
    
    private func stopLocationService() {
        locationService.stopUpdating()
    }
    
}
