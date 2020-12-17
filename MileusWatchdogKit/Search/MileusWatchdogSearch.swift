
import UIKit


public final class MileusWatchdogSearch {
    
    private static var alreadyInitialized = false
    
    internal weak var delegate: MileusWatchdogSearchFlowDelegate?
    internal var mode = MileusModeType.watchdog
    
    private(set) var origin: MileusWatchdogLocation?
    private(set) var destination: MileusWatchdogLocation?
    
    private var rootVC: UINavigationController?
    private weak var searchVM: SearchVM?
    
    public init(delegate: MileusWatchdogSearchFlowDelegate, origin: MileusWatchdogLocation? = nil, destination: MileusWatchdogLocation? = nil) throws {
        if !MileusWatchdogKit.isInitialized {
            throw MileusWatchdogError.sdkIsNotInitialized
        }
        if Self.alreadyInitialized {
            throw MileusWatchdogError.instanceAlreadyExists
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
            let bundle: Bundle
            #if SWIFT_PACKAGE
            bundle = Bundle.module
            #else
            bundle = Bundle(for: SearchVC.self)
            #endif
            let searchVC = UIStoryboard(name: "Search", bundle: bundle).instantiateInitialViewController() as! SearchVC
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
    
    public func updateOrigin(location: MileusWatchdogLocation) {
        self.origin = location
        searchVM?.coordinatesUpdated()
    }
    
    public func updateDestination(location: MileusWatchdogLocation) {
        self.destination = location
        searchVM?.coordinatesUpdated()
    }
    
    private func getURL() -> URL {
        let language = Locale.preferredLanguages.first ?? "en"
        let languageComponents = Locale.components(fromIdentifier: language)
        let languageCode = languageComponents[NSLocale.Key.languageCode.rawValue] ?? "en"
        var components = URLComponents(string: MileusWatchdogKit.environment!.url)!
        components.queryItems = [
            URLQueryItem(name: "access_token", value: MileusWatchdogKit.accessToken),
            URLQueryItem(name: "environment", value: MileusWatchdogKit.environment.key),
            URLQueryItem(name: "partner_name", value: MileusWatchdogKit.partnerName),
            URLQueryItem(name: "platform", value: "ios"),
            URLQueryItem(name: "language", value: languageCode),
            URLQueryItem(name: "mode", value: mode.rawValue)
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
