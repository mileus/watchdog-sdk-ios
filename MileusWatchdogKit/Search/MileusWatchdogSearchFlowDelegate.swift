
import Foundation


public protocol MileusWatchdogSearchFlowDelegate: AnyObject {
    
    func mileus(_ mileus: MileusWatchdogSearch, showSearch data: MileusWatchdogSearchData)
    func mileusShowTaxiRide(_ mileus: MileusWatchdogSearch)
    func mileusShowTaxiRideAndFinish(_ mileus: MileusWatchdogSearch)
    func mileusDidFinish(_ mileus: MileusWatchdogSearch)
    func mileusDidFinish(_ mileus: MileusWatchdogSearch, with error: MileusFlowError)
    
}
