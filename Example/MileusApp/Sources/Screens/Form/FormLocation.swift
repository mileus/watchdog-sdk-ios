
import Foundation


final class FormLocation {
    var addressFirstLine: String?
    var addressSecondLine: String?
    @LocationWrapper(value: nil)
    var latitude: String!
    @LocationWrapper(value: nil)
    var longitude: String!
    
    init(latitude: String?, longitude: String?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
