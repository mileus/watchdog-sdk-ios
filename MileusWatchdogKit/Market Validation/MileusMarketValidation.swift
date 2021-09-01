
import UIKit


public final class MileusMarketValidation {
    
    private static var alreadyInitialized = false
    
    internal private(set) weak var delegate: MileusMarketValidationFlowDelegate?
    
    private var mileusSearch: MileusWatchdogSearch!
    
    public init(delegate: MileusMarketValidationFlowDelegate, origin: MileusWatchdogLocation, destination: MileusWatchdogLocation) throws {
        if Self.alreadyInitialized {
            throw MileusWatchdogError.instanceAlreadyExists
        }
        self.delegate = delegate
        mileusSearch = try MileusWatchdogSearch(
            delegate: self,
            origin: origin,
            destination: destination,
            ignoreLocationPermission: true
        )
        mileusSearch.mode = .marketValidation
        Self.alreadyInitialized = true
    }
    
    deinit {
        Self.alreadyInitialized = false
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    public func show(from: UIViewController) -> UINavigationController {
        mileusSearch.show(from: from)
    }
    
}


extension MileusMarketValidation: MileusWatchdogSearchFlowDelegate {
   
    public func mileus(_ mileus: MileusWatchdogSearch, showSearch data: MileusWatchdogSearchData) {
        
    }
    
    public func mileusShowTaxiRide(_ mileus: MileusWatchdogSearch) {
        
    }
    
    public func mileusShowTaxiRideAndFinish(_ mileus: MileusWatchdogSearch) {
        
    }
    
    public func mileusDidFinish(_ mileus: MileusWatchdogSearch) {
        delegate?.mileusDidFinish(self)
    }
    
    public func mileusDidFinish(_ mileus: MileusWatchdogSearch, with error: MileusFlowError) {
        
    }
    
}
