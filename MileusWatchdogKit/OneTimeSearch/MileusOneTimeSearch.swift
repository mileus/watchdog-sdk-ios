
import UIKit


public final class MileusOneTimeSearch {
    
    private static var alreadyInitialized = false
    
    internal private(set) weak var delegate: MileusOneTimeSearchFlowDelegate?
    
    private var mileusSearch: MileusWatchdogSearch!
    
    public init(delegate: MileusOneTimeSearchFlowDelegate, explanationDialogKey: String) throws {
        if Self.alreadyInitialized {
            throw MileusWatchdogError.instanceAlreadyExists
        }
        self.delegate = delegate
        mileusSearch = try MileusWatchdogSearch(
            delegate: self,
            locations: [],
            ignoreLocationPermission: false
        )
        mileusSearch.mode = .oneTimeSearch
        
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


extension MileusOneTimeSearch: MileusWatchdogSearchFlowDelegate {
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
        delegate?.mileusDidFinish(self, with: error)
    }
}
