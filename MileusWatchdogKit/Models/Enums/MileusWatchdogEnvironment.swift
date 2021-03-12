
import Foundation


public enum MileusWatchdogEnvironment: CaseIterable {
    
    case development
    case staging
    case production
    
    internal var url: String {
        switch self {
        case .development:
            return "https://mileus-spacek.vercel.app/"
        case .staging:
            return "https://api-stage.mileus.com/"
        case .production:
            return "https://watchdog-web.mileus.com/"
        }
    }
    
    internal var key: String {
        switch self {
        case .development:
            return "development"
        case .staging:
            return "staging"
        case .production:
            return "production"
        }
    }
    
}
