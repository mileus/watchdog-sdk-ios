
import Foundation
import MileusWatchdogKit


protocol LocationFormDelegate {
    
    func locationForm(_ locationForm: LocationFormVM, didFinish location: MileusWatchdogLocation)
    
}


class LocationFormVM {
    
    var addressFirstLine: String?
    var addressSecondLine: String?
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
        addressFirstLine = location.address?.firstLine
        addressSecondLine = location.address?.secondLine
        $latitude = location.latitude
        $longitude = location.longitude
    }
    
    func save() {
        let location = MileusWatchdogLocation(
            address: getAddress(),
            latitude: $latitude,
            longitude: $longitude
        )
        delegate.locationForm(self, didFinish: location)
    }
    
    private func getAddress() -> MileusWatchdogAddress? {
        guard let firstLine = addressFirstLine else {
            return nil
        }
        return .init(
            firstLine: firstLine,
            secondLine: addressSecondLine
        )
    }
    
}
