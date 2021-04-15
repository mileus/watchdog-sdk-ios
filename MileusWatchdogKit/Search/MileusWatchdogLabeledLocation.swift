
import Foundation


internal struct MileusWatchdogLabeledLocation {
    let label: MileusWatchdogLocationType
    let data: MileusWatchdogLocation
}


internal enum MileusWatchdogLocationType: String {
    case origin = "origin"
    case destination = "destination"
    case home = "home"
    
    var searchType: MileusWatchdogSearchType {
        MileusWatchdogSearchType(raw: rawValue)!
    }
}
