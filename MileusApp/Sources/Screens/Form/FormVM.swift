
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
        
        originAddress = "Prague - Nové Město"
        originLatitude = formatCoordinateToView("50.091266")
        originLongitude = formatCoordinateToView("14.438927")
        destinationAddress = "Holešovice"
        destinationLatitude = formatCoordinateToView("50.121765629793295")
        destinationLongitude = formatCoordinateToView("14.489431312606477")
    }
    
    func getOrigin() -> MileusLocation {
        return MileusLocation(address: originAddress,
                              latitude: Double(formatCoordinateFromView(originLatitude)) ?? 0.0,
                              longitude: Double(formatCoordinateFromView(originLongitude)) ?? 0.0
        )
    }
    
    func getDestination() -> MileusLocation {
        return MileusLocation(address: destinationAddress,
                              latitude: Double(formatCoordinateFromView(destinationLatitude)) ?? 0.0,
                              longitude: Double(formatCoordinateFromView(destinationLongitude)) ?? 0.0
        )
    }
    
    func search(from: UIViewController, delegate: MileusSearchFlowDelegate) -> UIViewController {
        config.accessToken = accessToken
        
        let token = (accessToken?.isEmpty ?? true) ? "unknown-token-ios-test-app" : accessToken!
        try! MileusKit.configure(partnerName: "ios-test-app", accessToken: token, environment: .staging)
        mileusSearch = try! MileusSearch(delegate: delegate, origin: getOrigin(), destination: getDestination())
        
        return mileusSearch!.show(from: from)
    }
    
    private func formatCoordinateToView(_ string: String) -> String {
        let sep = Locale.current.decimalSeparator ?? "."
        return string.replacingOccurrences(of: ".", with: sep)
    }
    
    private func formatCoordinateFromView(_ string: String) -> String {
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
}
