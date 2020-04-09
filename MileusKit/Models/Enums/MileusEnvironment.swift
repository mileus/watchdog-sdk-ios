
import Foundation


public enum MileusEnvironment {
    
    case staging
    case production
    
    internal var url: String {
        switch self {
        case .staging:
            return "https://mileus.spacek.now.sh/"
        case .production:
            return "https://watchdog-web.mileus.com/"
        }
    }
    
    internal var key: String {
        switch self {
        case .staging:
            return "staging"
        case .production:
            return "production"
        }
    }
    
}
