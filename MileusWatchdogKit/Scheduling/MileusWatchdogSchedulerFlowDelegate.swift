
import Foundation


public protocol MileusWatchdogSchedulerFlowDelegate: class {
    
    func mileusDidFinish(_ mileus: MileusWatchdogScheduler)
    func mileus(_ mileus: MileusWatchdogScheduler, showSearch data: MileusWatchdogSearchData)
    
}
