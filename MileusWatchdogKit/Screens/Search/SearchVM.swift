
import Foundation


class SearchVM: NSObject, WebViewMessagesDelegate {
    
    private(set) weak var search: MileusWatchdogSearch!
    
    lazy var messages: [WebViewMessage] = {
        [
            OpenSearchMessage(action: { [weak self] data in self?.openSearch(data: data) }),
            OpenTaxiRideMessage(action: { [weak self] in self?.openTaxiRide() }),
            OpenTaxiRideScreenAndFinishMessage(action: { [weak self] in self?.openTaxiRideAndFinish() }),
            CloseMarketValidationMessage(action: { [weak self] in self?.didFinish() })
        ]
    }()
    
    var updateCoordinates: (() -> Void)?
    let urlHandler: () -> URL
    
    private let inputSanitizer = InputSanitizer()
    
    init(search: MileusWatchdogSearch, urlHandler: @escaping () -> URL) {
        self.search = search
        self.urlHandler = urlHandler
        
        super.init()
    }
    
    deinit {
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    func getURL() -> URL {
        return urlHandler()
    }
    
    func getOrigin() -> String? {
        if let location = search.origin {
            return formatLocation(location: location)
        }
        return nil
    }
    
    func getDestination() -> String? {
        if let location = search.destination {
            return formatLocation(location: location)
        }
        return nil
    }
    
    func getHome() -> String? {
        if let location = search.home {
            return formatLocation(location: location)
        }
        return nil
    }
    
    func coordinatesUpdated() {
        updateCoordinates?()
    }
    
    func didFinish() {
        DispatchQueue.main.async { [unowned self] in
            self.search?.delegate?.mileusDidFinish(self.search)
        }
    }
    
    func openSearch(data: [String : String]) {
        guard let rawSearchType = data["search_type"], let searchType = MileusWatchdogSearchType(raw: rawSearchType)  else {
            return
        }
        let searchDate = MileusWatchdogSearchData(
            type: searchType,
            origin: search.origin,
            destination: search.destination,
            home: search.home
        )
        DispatchQueue.main.async {
            self.search?.delegate?.mileus(self.search, showSearch: searchDate)
        }
    }
    
    func openTaxiRide() {
        DispatchQueue.main.async {
            self.search?.delegate?.mileusShowTaxiRide(self.search)
        }
    }
    
    func openTaxiRideAndFinish() {
        DispatchQueue.main.async {
            self.search?.delegate?.mileusShowTaxiRideAndFinish(self.search)
        }
    }
    
    private func formatLocation(location: MileusWatchdogLocation) -> String {
        return "{'lat': \(location.latitude), 'lon': \(location.longitude), 'address_line_1': '\(inputSanitizer.sanitizeJS(location.address?.firstLine ?? ""))', 'address_line_2': '\(inputSanitizer.sanitizeJS(location.address?.secondLine ?? ""))', 'accuracy': \(location.accuracy)}"
    }
    
}
