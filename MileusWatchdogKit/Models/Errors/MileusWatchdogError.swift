
import Foundation


public enum MileusWatchdogError: Error {
    
    case invalidInput
    case instanceAlreadyExists
    case sdkIsNotInitialized
    case insufficientLocationPermission
    case fatalInvalidState(message: String)
    case unknown
    
}
