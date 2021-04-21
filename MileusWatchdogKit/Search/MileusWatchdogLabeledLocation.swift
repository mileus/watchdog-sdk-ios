
import Foundation


internal struct MileusWatchdogLabeledLocation {
    let label: MileusWatchdogLocationType
    let data: MileusWatchdogLocation
}


internal enum MileusWatchdogLocationType: String {
    case origin = "origin"
    case destination = "destination"
    case home = "home"
    
    init(type: MileusWatchdogSearchType) {
        switch type {
        case .origin:
            self = .origin
        case .destination:
            self = .destination
        case .home:
            self = .home
        }
    }
    
    var searchType: MileusWatchdogSearchType {
        MileusWatchdogSearchType(raw: rawValue)!
    }
}
