
import Foundation


internal final class InputSanitizer {
    
    func sanitizeJS(_ input: String) -> String {
        return input
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
    }
    
}

