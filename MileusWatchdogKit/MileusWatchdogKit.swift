
import Foundation


public final class MileusWatchdogKit {
    
    internal static var partnerName: String!
    internal static var accessToken: String!
    internal static var environment: MileusWatchdogEnvironment!
    
    internal static var isInitialized: Bool {
        return accessToken != nil
    }
    
    public static func configure(partnerName: String, accessToken: String, environment: MileusWatchdogEnvironment) throws {
        if partnerName.isEmpty || accessToken.isEmpty {
            throw MileusWatchdogError.invalidInput
        }
        self.partnerName = partnerName
        self.accessToken = accessToken
        self.environment = environment
    }
    
}
