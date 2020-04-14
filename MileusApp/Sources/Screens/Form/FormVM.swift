
import UIKit
import MileusKit


class FormVM {
    
    var accessToken: String?
    var originAddress: String!
    var originLatitude: String!
    var originLongitude: String!
    var destinationAddress: String!
    var destinationLatitude: String!
    var destinationLongitude: String!
    
    var mileusSearch: MileusSearch?
    
    private let config: Config
    
    init() {
        config = Config.shared
        accessToken = config.accessToken
        
#if DEBUG
        accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaSI6MTIzNDUsInBuIjoiZHVtbXktcGFydG5lciIsInBlaSI6ImV4dGVybmFsLXBhc3Nlbmdlci1pZCIsImlhdCI6MTU4NTE0MTAwNn0.0vyb_yjUH4RQ1lyhSiao3h6JdJagQBy_QZXyPWRr9NU"
#endif
    }
    
    func getOrigin() -> MileusLocation {
        return MileusLocation(address: originAddress, latitude: Double(originLatitude) ?? 0.0, longitude: Double(originLongitude) ?? 0.0)
    }
    
    func getDestination() -> MileusLocation {
        return MileusLocation(address: destinationAddress, latitude: Double(destinationLatitude) ?? 0.0, longitude: Double(destinationLongitude) ?? 0.0)
    }
    
    func search(from: UIViewController, delegate: MileusSearchFlowDelegate) -> UIViewController {
        config.accessToken = accessToken
        
        let token = (accessToken?.isEmpty ?? true) ? "unknown-token-ios-test-app" : accessToken!
        try! MileusKit.configure(partnerName: "ios-test-app", accessToken: token, environment: .staging)
        mileusSearch = try! MileusSearch(delegate: delegate, origin: getOrigin(), destination: getDestination())
        
        return mileusSearch!.show(from: from)
    }
    
    func formatCoordinate(_ string: String?) -> String? {
        return string?.replacingOccurrences(of: ",", with: ".")
    }
    
}
