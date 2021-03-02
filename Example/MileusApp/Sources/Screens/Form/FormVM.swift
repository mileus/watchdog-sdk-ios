
import UIKit
import MileusWatchdogKit


class FormVM {
    
    var accessToken: String? {
        didSet {
            config.accessToken = accessToken
        }
    }
    var partnerName: String? {
        didSet {
            config.partnerName = partnerName
        }
    }
    var originAddress: String!
    @LocationWrapper(value: "50.091266")
    var originLatitude: String!
    @LocationWrapper(value: "14.438927")
    var originLongitude: String!
    var destinationAddress: String!
    @LocationWrapper(value: "50.121765629793295")
    var destinationLatitude: String!
    @LocationWrapper(value: "14.489431312606477")
    var destinationLongitude: String!
    
    var selectedEnvironmentIndex = 0
    let environments: [String]
    
    var mileusSearch: MileusWatchdogSearch?
    var mileusMarketValidation: MileusMarketValidation?
    var mileusWatchdogScheduler: MileusWatchdogScheduler?
    var searchData: MileusWatchdogSearchData?
    
    private let config: Config
    
    init() {
        config = Config.shared
        accessToken = config.accessToken
        environments = MileusWatchdogEnvironment.allCases.map({ String(describing: $0) })
        selectedEnvironmentIndex = MileusWatchdogEnvironment.allCases.firstIndex(of: .staging) ?? 0
        partnerName = getPartnerName(useSaved: true)
        
#if DEBUG
        accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGkiOiJmOGEzYzg4NS1mYmI2LTQxYTItYjhhOC0yZDA2OTQxODZmYTkiLCJwbiI6ImR1bW15LXBhcnRuZXIiLCJwZWkiOiJleHRlcm5hbC1wYXNzZW5nZXItaWQiLCJpYXQiOjE1OTQyNjk3NTl9.Goanc61n9jzC6wz88FktRa5u2ESZ6SneiJipO_90Jsk"
#endif
        
        originAddress = "Prague - Nové Město"
        destinationAddress = "Not Prague center"
    }
    
    func getOrigin() -> MileusWatchdogLocation {
        return MileusWatchdogLocation(address: originAddress,
                              latitude: $originLatitude,
                              longitude: $originLongitude
        )
    }
    
    func getDestination() -> MileusWatchdogLocation {
        return MileusWatchdogLocation(address: destinationAddress,
                              latitude: $destinationLatitude,
                              longitude: $destinationLongitude
        )
    }
    
    func search(from: UIViewController, delegate: MileusWatchdogSearchFlowDelegate) -> UIViewController {
        reinitSDK()
        mileusSearch = try! MileusWatchdogSearch(delegate: delegate, origin: getOrigin(), destination: getDestination())
        
        return mileusSearch!.show(from: from)
    }
    
    func validation(from: UIViewController, delegate: MileusMarketValidationFlowDelegate) -> UIViewController {
        reinitSDK()
        mileusMarketValidation = try! MileusMarketValidation(delegate: delegate, origin: getOrigin(), destination: getDestination())
        
        return mileusMarketValidation!.show(from: from)
    }
    
    func scheduler(from: UIViewController, delegate: MileusWatchdogSchedulerFlowDelegate) -> UIViewController {
        reinitSDK()
        mileusWatchdogScheduler = try! MileusWatchdogScheduler(delegate: delegate, homeLocation: nil)
        
        return mileusWatchdogScheduler!.show(from: from)
    }
    
    func updateLocation(location: MileusWatchdogLocation) {
        guard let data = searchData else {
            return
        }
        switch data.type {
        case .origin:
            mileusSearch?.updateOrigin(location: location)
        case .destination:
            mileusSearch?.updateDestination(location: location)
        }
    }
    
    @inline(__always)
    private func getToken() -> String {
        (accessToken?.isEmpty ?? true) ? "unknown-token-ios-test-app" : accessToken!
    }
    
    @inline(__always)
    private func getPartnerName(useSaved: Bool) -> String {
        let partnerName = useSaved ? config.partnerName : self.partnerName
        return (partnerName?.isEmpty ?? true) ? "demo" :  partnerName!
    }

    private func reinitSDK() {
        let environment = MileusWatchdogEnvironment.allCases[selectedEnvironmentIndex]
        try! MileusWatchdogKit.configure(partnerName: getPartnerName(useSaved: false), accessToken: getToken(), environment: environment)
    }
    
}
