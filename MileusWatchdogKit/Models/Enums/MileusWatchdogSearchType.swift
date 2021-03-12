
import Foundation


public enum MileusWatchdogSearchType {
    
    case origin
    case destination
    case home
    
    internal init?(raw: String) {
        if raw == "origin" {
            self = .origin
        } else if raw == "destination" {
            self = .destination
        } else if raw == "home" {
            self = .home
        } else {
            return nil
        }
    }
    
}
