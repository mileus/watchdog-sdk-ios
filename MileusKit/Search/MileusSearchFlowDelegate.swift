
import Foundation


public protocol MileusSearchFlowDelegate: class {
    
    func mileus(_ mileus: MileusSearch, showSearch data: MileusSearchData)
    func mileusShowTaxiRide(_ mileus: MileusSearch)
    func mileusShowTaxiRideAndFinish(_ mileus: MileusSearch)
    func mileusDidFinish(_ mileus: MileusSearch)
    
}
