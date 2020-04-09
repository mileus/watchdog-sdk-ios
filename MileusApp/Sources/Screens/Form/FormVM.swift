
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
    
    init() {
        
    }
    
    func getOrigin() -> MileusLocation {
        return MileusLocation(address: originAddress, latitude: Double(originLatitude) ?? 0.0, longitude: Double(originLongitude) ?? 0.0)
    }
    
    func getDestination() -> MileusLocation {
        return MileusLocation(address: destinationAddress, latitude: Double(destinationLatitude) ?? 0.0, longitude: Double(destinationLongitude) ?? 0.0)
    }
    
    func search(from: UIViewController, delegate: MileusSearchFlowDelegate) -> UIViewController {
        if accessToken?.isEmpty ?? true {
            accessToken = "unknown-token-ios-test-app"
        }
        try! MileusKit.configure(partnerName: "ios-test-app", accessToken: accessToken!, environment: .staging)
        mileusSearch = try! MileusSearch(delegate: delegate, origin: getOrigin(), destination: getDestination())
        
        /*DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 12.0) {
            self.originAddress = "Praha 1"
            self.mileusSearch?.updateOrigin(location: self.getOrigin())
        }*/
        return mileusSearch!.show(from: from)
    }
    
}
