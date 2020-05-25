
import Foundation
import MileusWatchdogKit


protocol LocationFormDelegate {
    
    func locationForm(_ locationForm: LocationFormVM, didFinish location: MileusWatchdogLocation)
    
}


class LocationFormVM {
    
    var address: String!
    @LocationWrapper(value: nil)
    var latitude: String!
    @LocationWrapper(value: nil)
    var longitude: String!
    
    private let searchData: MileusWatchdogSearchData
    private let delegate: LocationFormDelegate
    
    init(searchData: MileusWatchdogSearchData, delegate: LocationFormDelegate) {
        self.searchData = searchData
        self.delegate = delegate
        
        let location = searchData.type == .destination ? searchData.destination : searchData.origin
        address = location.address
        $latitude = location.latitude
        $longitude = location.longitude
    }
    
    func save() {
        let location = MileusWatchdogLocation(address: address, latitude: $latitude, longitude: $longitude)
        delegate.locationForm(self, didFinish: location)
    }
    
}
