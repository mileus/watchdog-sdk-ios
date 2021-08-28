
import UIKit


public final class MileusWatchdogSearch {
    
    private static var alreadyInitialized = false
    
    internal var delegate: MileusWatchdogSearchFlowDelegate?
    internal var mode = MileusModeType.watchdog
    
    private var locations: [MileusWatchdogLabeledLocation]
    private var explanationDialogKey: String?
    
    private var rootVC: UINavigationController?
    private weak var searchVM: SearchVM?
    
    public convenience init(delegate: MileusWatchdogSearchFlowDelegate, origin: MileusWatchdogLocation? = nil, destination: MileusWatchdogLocation? = nil) throws {
        try self.init(delegate: delegate, origin: origin, destination: destination, ignoreLocationPermission: false)
    }
    
    internal convenience init(delegate: MileusWatchdogSearchFlowDelegate, origin: MileusWatchdogLocation? = nil, destination: MileusWatchdogLocation? = nil, ignoreLocationPermission: Bool) throws {
        var locations = [MileusWatchdogLabeledLocation]()
        if let origin = origin {
            let labeledLocation = MileusWatchdogLabeledLocation(label: .origin, data: origin)
            locations.append(labeledLocation)
        }
        if let destination = destination {
            let labeledLocation = MileusWatchdogLabeledLocation(label: .destination, data: destination)
            locations.append(labeledLocation)
        }
        try self.init(delegate: delegate, locations: locations, ignoreLocationPermission: ignoreLocationPermission)
    }
    
    internal init(delegate: MileusWatchdogSearchFlowDelegate, locations: [MileusWatchdogLabeledLocation], ignoreLocationPermission: Bool) throws {
        if !MileusWatchdogKit.isInitialized {
            throw MileusWatchdogError.sdkIsNotInitialized
        }
        if Self.alreadyInitialized {
            throw MileusWatchdogError.instanceAlreadyExists
        }
        if !ignoreLocationPermission && !CoreLocationService().isAllowed {
            throw MileusWatchdogError.insufficientLocationPermission
        }
        self.delegate = MainDispatchDecorator(decoratee: delegate)
        self.locations = locations
        Self.alreadyInitialized = true
    }
    
    internal convenience init(delegate: MileusWatchdogSearchFlowDelegate, explanationDialogKey: String, ignoreLocationPermission: Bool) throws {
        try self.init(delegate: delegate)
        self.explanationDialogKey = explanationDialogKey
    }
    
    deinit {
        Self.alreadyInitialized = false
        rootVC?.setViewControllers([], animated: false)
        rootVC = nil
        searchVM = nil
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    public func show(from: UIViewController) -> UINavigationController {
        if rootVC == nil {
            let searchVC = UIStoryboard(name: "Search", bundle: Bundle.bundle(for: SearchVC.self)).instantiateInitialViewController() as! SearchVC
            searchVC.viewModel = SearchVM(search: self, urlHandler: { [unowned self] in self.getURL() })
            searchVM = searchVC.viewModel
            rootVC = MainNC(rootViewController: searchVC)
            rootVC?.modalPresentationStyle = .fullScreen
        }
        if rootVC?.presentingViewController == nil {
            from.show(rootVC!, sender: nil)
        }
        rootVC!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0)]
        return rootVC!
    }
    
    public func update(location: MileusWatchdogLocation, type: MileusWatchdogSearchType) {
        updateLocation(location: location, type: MileusWatchdogLocationType(type: type))
        searchVM?.coordinatesUpdated()
    }
    
    public func update(searchData: MileusWatchdogSearchData) {
        updateLocation(location: searchData.location, type: MileusWatchdogLocationType(type: searchData.type))
        searchVM?.coordinatesUpdated()
    }
    
    internal func location(of type: MileusWatchdogLocationType) -> MileusWatchdogLocation? {
        locations.first(where: { $0.label == type })?.data
    }
    
    private func updateLocation(location: MileusWatchdogLocation, type: MileusWatchdogLocationType) {
        locations.removeAll(where: { $0.label == type })
        locations.append(.init(label: type, data: location))
    }
    
    private func getURL() -> URL {
        let language = Locale.preferredLanguages.first ?? "en"
        let languageComponents = Locale.components(fromIdentifier: language)
        let languageCode = languageComponents[NSLocale.Key.languageCode.rawValue] ?? "en"
        var components = URLComponents(string: MileusWatchdogKit.environment!.webURL)!
        components.queryItems = [
            URLQueryItem(name: "access_token", value: MileusWatchdogKit.accessToken),
            URLQueryItem(name: "environment", value: MileusWatchdogKit.environment.key),
            URLQueryItem(name: "partner_name", value: MileusWatchdogKit.partnerName),
            URLQueryItem(name: "platform", value: "ios"),
            URLQueryItem(name: "language", value: languageCode),
            URLQueryItem(name: "screen", value: mode.rawValue)
        ]
        if let explanationDialogKey = explanationDialogKey {
            components.queryItems?.append(URLQueryItem(name: "str_key_explanation_dialog", value: explanationDialogKey))
        }
        for location in locations {
            let prefix = location.label.rawValue
            if let addressFirstLine = location.data.address?.firstLine {
                components.queryItems?.append(URLQueryItem(name: "\(prefix)_address_line_1", value: String(addressFirstLine)))
            }
            if let addressSecondLine = location.data.address?.secondLine {
                components.queryItems?.append(URLQueryItem(name: "\(prefix)_address_line_2", value: String(addressSecondLine)))
            }
            components.queryItems?.append(URLQueryItem(name: "\(prefix)_lat", value: String(location.data.latitude)))
            components.queryItems?.append(URLQueryItem(name: "\(prefix)_lon", value: String(location.data.longitude)))
        }
        return components.url!
    }
    
}
