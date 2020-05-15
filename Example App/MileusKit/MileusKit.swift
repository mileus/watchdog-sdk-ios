
import Foundation


public final class MileusKit {
    
    internal static var partnerName: String!
    internal static var accessToken: String!
    internal static var environment: MileusEnvironment!
    
    internal static var isInitialized: Bool {
        return accessToken != nil
    }
    
    public static func configure(partnerName: String, accessToken: String, environment: MileusEnvironment) throws {
        if partnerName.isEmpty || accessToken.isEmpty {
            throw MileusError.invalidInput
        }
        self.partnerName = partnerName
        self.accessToken = accessToken
        self.environment = environment
    }
    
}
