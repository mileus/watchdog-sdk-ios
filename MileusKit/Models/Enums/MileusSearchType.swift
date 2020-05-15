
import Foundation


public enum MileusSearchType {
    
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
