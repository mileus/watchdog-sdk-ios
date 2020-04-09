
import UIKit


public final class MileusSearch {
    
    private static var alreadyInitialized = false
    
    internal weak var delegate: MileusSearchFlowDelegate?
    
    private(set) var origin: MileusLocation?
    private(set) var destination: MileusLocation?
    
    private var rootVC: UINavigationController?
    private weak var searchVM: SearchVM?
    
    public init?(delegate: MileusSearchFlowDelegate, origin: MileusLocation? = nil, destination: MileusLocation? = nil) throws {
        if !MileusKit.isInitialized {
            throw MileusError.sdkIsNotInitialized
        }
        if Self.alreadyInitialized {
            throw MileusError.instanceAlreadyExists
        }
        self.delegate = delegate
        self.origin = origin
        self.destination = destination
        Self.alreadyInitialized = true
    }
    
    deinit {
        Self.alreadyInitialized = false
        rootVC?.setViewControllers([], animated: false)
        rootVC = nil
        searchVM = nil
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    public func show(from: UIViewController) -> UIViewController {
        if rootVC == nil {
            let searchVC = UIStoryboard(name: "Search", bundle: Bundle(for: MileusSearch.self)).instantiateInitialViewController() as! SearchVC
            searchVC.viewModel = SearchVM(search: self, urlHandler: { [unowned self] in self.getURL() })
            searchVM = searchVC.viewModel
            rootVC = MainNC(rootViewController: searchVC)
            rootVC?.modalPresentationStyle = .fullScreen
        }
        if rootVC?.presentingViewController == nil {
            from.show(rootVC!, sender: nil)
        }
        return rootVC!
    }
    
    public func updateOrigin(location: MileusLocation) {
        self.origin = location
        searchVM?.coordinatesUpdated()
    }
    
    public func updateDestination(location: MileusLocation) {
        self.destination = location
        searchVM?.coordinatesUpdated()
    }
    
    private func getURL() -> URL {
        var components = URLComponents(string: MileusKit.environment!.url)!
        components.queryItems = [
            URLQueryItem(name: "access_token", value: MileusKit.accessToken),
            URLQueryItem(name: "environment", value: MileusKit.environment.key),
            URLQueryItem(name: "partner_name", value: MileusKit.partnerName)
        ]
        if let origin = self.origin {
            components.queryItems?.append(URLQueryItem(name: "origin_address", value: String(origin.address)))
            components.queryItems?.append(URLQueryItem(name: "origin_lat", value: String(origin.latitude)))
            components.queryItems?.append(URLQueryItem(name: "origin_lon", value: String(origin.longitude)))
        }
        if let destination = self.destination {
            components.queryItems?.append(URLQueryItem(name: "destination_address", value: String(destination.address)))
            components.queryItems?.append(URLQueryItem(name: "destination_lat", value: String(destination.latitude)))
            components.queryItems?.append(URLQueryItem(name: "destination_lon", value: String(destination.longitude)))
        }
        return components.url!
    }
    
}
