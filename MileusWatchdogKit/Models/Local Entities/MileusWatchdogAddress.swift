
import Foundation


public struct MileusWatchdogAddress {
    
    public let firstLine: String
    public let secondLine: String?
    
    public init(firstLine: String, secondLine: String?) {
        self.firstLine = firstLine
        self.secondLine = secondLine
    }
    
}
