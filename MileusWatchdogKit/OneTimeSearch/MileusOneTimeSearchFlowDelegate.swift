
import Foundation


public protocol MileusOneTimeSearchFlowDelegate: AnyObject {
    func mileusDidFinish(_ mileus: MileusOneTimeSearch)
    func mileusDidFinish(_ mileus: MileusOneTimeSearch, with error: MileusFlowError)
    func mileusShowTaxiRide(_ mileus: MileusOneTimeSearch)
    func mileusShowTaxiRideAndFinish(_ mileus: MileusOneTimeSearch)
}
