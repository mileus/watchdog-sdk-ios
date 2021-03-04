
import Foundation


protocol BodyRequest: Encodable {
    
}

extension BodyRequest {
    func asData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
