
import Foundation


public protocol MileusWatchdogSchedulerFlowDelegate: AnyObject {
    
    func mileusDidFinish(_ mileus: MileusWatchdogScheduler)
    func mileus(_ mileus: MileusWatchdogScheduler, showSearch data: MileusWatchdogSearchData)
    
}
