
import UIKit


public final class MileusWatchdogScheduler {
    
    private static var alreadyInitialized = false
    
    internal private(set) weak var delegate: MileusWatchdogSchedulerFlowDelegate?
    
    private var mileusSearch: MileusWatchdogSearch!
    
    public init(delegate: MileusWatchdogSchedulerFlowDelegate, homeLocation: MileusWatchdogLocation? = nil) throws {
        if Self.alreadyInitialized {
            throw MileusWatchdogError.instanceAlreadyExists
        }
        self.delegate = delegate
        let locations = homeLocation == nil ? [] : [MileusWatchdogLabeledLocation(label: .home, data: homeLocation!)]
        mileusSearch = try MileusWatchdogSearch(delegate: self, locations: locations)
        mileusSearch.mode = .watchdogScheduler
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


extension MileusWatchdogScheduler: MileusWatchdogSearchFlowDelegate {
    
    public func mileus(_ mileus: MileusWatchdogSearch, showSearch data: MileusWatchdogSearchData) {
        
    }
    
    public func mileusShowTaxiRide(_ mileus: MileusWatchdogSearch) {
        
    }
    
    public func mileusShowTaxiRideAndFinish(_ mileus: MileusWatchdogSearch) {
        
    }
    
    public func mileusDidFinish(_ mileus: MileusWatchdogSearch) {
        delegate?.mileusDidFinish(self)
    }
    
}
