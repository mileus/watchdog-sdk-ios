
import Foundation


public enum MileusWatchdogSearchType {
    
    case origin
    case destination
    
    internal init?(raw: String) {
        if raw == "origin" {
            self = .origin
        } else if raw == "destination" {
            self = .destination
        } else {
            return nil
        }
    }
    
}
