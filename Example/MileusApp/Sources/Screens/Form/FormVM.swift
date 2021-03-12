
import Foundation
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
    
    var originLocation = FormLocation(latitude: "50.091266", longitude: "14.438927")
    var destinationLocation = FormLocation(latitude: "50.121765629793295", longitude: "14.489431312606477")
    var homeLocation = FormLocation(latitude: nil, longitude: nil)
    
    var selectedEnvironmentIndex = 0
    let environments: [String]
    
    var mileusSearch: MileusWatchdogSearch?
    var mileusMarketValidation: MileusMarketValidation?
    var mileusWatchdogScheduler: MileusWatchdogScheduler?
    var mileusWatchdogLocationSync: MileusWatchdogLocationSync?
    var searchData: MileusWatchdogSearchData?
    
    private let config: Config
    
    init() {
        config = Config.shared
        accessToken = config.accessToken
        environments = MileusWatchdogEnvironment.allCases.map({ String(describing: $0) })
        selectedEnvironmentIndex = MileusWatchdogEnvironment.allCases.firstIndex(of: .staging) ?? 0
        partnerName = getPartnerName(useSaved: true)
        
#if DEBUG
        accessToken = "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJqaWQiOiJmYjVhYmY4My04MTg1LTQ5ZTMtODk0OC02YWVkZGNhZDExYzYiLCJyIjpbIlJIX1BBUyJdLCJhaSI6ImY4YTNjODg1LWZiYjYtNDFhMi1iOGE4LTJkMDY5NDE4NmZhOSIsInBuIjoiZHVtbXktcGFydG5lciIsInBpIjoiYTUzNTczMTgtMjBkNi00ODQ2LThjNGEtOWJjNGVhYjQ3MDQ4IiwicGVpIjoiZXh0ZXJuYWwtcGFzc2VuZ2VyLWlkIiwiaWF0IjoxNjE0NzY1NTk1LCJleHAiOjE2MTUzNzAzOTV9.AIY9bEfvHTtFFlEngsfpr4I9TJGx2EOQ7fvZY3aW3nl3Aq4PSt3TFrOUcLUc9cN3oLWv04nPjWcLGLtdpg8FBjkvAHXHgKE98J_Swbd4SotupFkI_XTxfWz_rGRZs-bbkEtkSholfDEI-9dKNQYoEGs_Q2MJ1e_xeZDqFcxRY6QU0i3s"
#endif
        
        originLocation.addressFirstLine = "Prague - Nové Město"
        destinationLocation.addressFirstLine = "Not Prague center"
    }
    
    private func getOrigin() -> MileusWatchdogLocation {
        getLocation(location: originLocation)
    }
    
    private func getDestination() -> MileusWatchdogLocation {
        getLocation(location: destinationLocation)
    }
    
    private func getHome() -> MileusWatchdogLocation {
        getLocation(location: destinationLocation)
    }
    
    private func getLocation(location: FormLocation) -> MileusWatchdogLocation {
        MileusWatchdogLocation(
            address: getAddress(
                firstLine: location.addressFirstLine,
                secondLine: location.addressSecondLine
            ),
            latitude: location.$latitude,
            longitude: location.$longitude
        )
    }
    
    private func getAddress(firstLine: String?, secondLine: String?) -> MileusWatchdogAddress? {
        guard let firstLine = firstLine else {
            return nil
        }
        return .init(firstLine: firstLine, secondLine: secondLine)
    }
    
    func search(delegate: MileusWatchdogSearchFlowDelegate) -> MileusWatchdogSearch {
        reinitSDK()
        mileusSearch = try! MileusWatchdogSearch(delegate: delegate, origin: getOrigin(), destination: getDestination())
        
        return mileusSearch!
    }
    
    func validation(delegate: MileusMarketValidationFlowDelegate) -> MileusMarketValidation {
        reinitSDK()
        mileusMarketValidation = try! MileusMarketValidation(delegate: delegate, origin: getOrigin(), destination: getDestination())
        
        return mileusMarketValidation!
    }
    
    func scheduler(delegate: MileusWatchdogSchedulerFlowDelegate) -> MileusWatchdogScheduler {
        reinitSDK()
        mileusWatchdogScheduler = try! MileusWatchdogScheduler(delegate: delegate, homeLocation: getHome())
        
        return mileusWatchdogScheduler!
    }
    
    func locationSync(completion: @escaping () -> Void) {
        reinitSDK()
        mileusWatchdogLocationSync = try! MileusWatchdogLocationSync()
        mileusWatchdogLocationSync?.start(completion: { [weak self] in
            completion()
            self?.mileusWatchdogLocationSync = nil
        })
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
        case .home:
            mileusSearch?.updateHome(location: location)
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
