
import Foundation


class SearchVM: NSObject, WebViewMessagesDelegate {
    
    private(set) weak var search: MileusWatchdogSearch!
    
    lazy var messages: [WebViewMessage] = {
        [
            OpenSearchMessage(action: { [weak self] data in self?.openSearch(data: data) }),
            OpenTaxiRideMessage(action: { [weak self] in self?.openTaxiRide() }),
            OpenTaxiRideScreenAndFinishMessage(action: { [weak self] in self?.openTaxiRideAndFinish() }),
            CloseMarketValidationMessage(action: { [weak self] in self?.didFinish() }),
            LocationScanningMessage(action: { [weak self] in self?.startLocationScanning() }),
            FinishFlowMessage(action: { [weak self] in self?.didFinish() }),
            FinishFlowMessageWithError(action: { [weak self] (error) in self?.didFinish(with: error) }),
            SendSMSMessage(action: { [weak self] number, body in self?.sendSMS(number: number, body: body) })
        ]
    }()
    
    var updateCoordinates: (() -> Void)?
    let urlHandler: () -> URL
    
    private let inputSanitizer = InputSanitizer()
    private var mileusWatchdogLocationSync: MileusWatchdogLocationSync?
    
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
        if let location = search.location(of: .origin) {
            return formatLocation(location: location)
        }
        return nil
    }
    
    func getDestination() -> String? {
        if let location = search.location(of: .destination) {
            return formatLocation(location: location)
        }
        return nil
    }
    
    func getHome() -> String? {
        if let location = search.location(of: .home) {
            return formatLocation(location: location)
        }
        return nil
    }
    
    func coordinatesUpdated() {
        updateCoordinates?()
    }
    
    func didFinish() {
        search?.delegate?.mileusDidFinish(search)
    }
    
    func didFinish(with error: MileusFlowError) {
        search?.delegate?.mileusDidFinish(search)
    }
    
    func sendSMS(number: String, body: String) {
        search.sendSMS(to: number, with: body)
    }
    
    func openSearch(data: MileusWatchdogLabeledLocation) {
        let searchData = MileusWatchdogSearchData(
            type: data.label.searchType,
            location: data.data
        )
        search?.delegate?.mileus(search, showSearch: searchData)
    }
    
    func openTaxiRide() {
        search?.delegate?.mileusShowTaxiRide(search)
    }
    
    func openTaxiRideAndFinish() {
        search?.delegate?.mileusShowTaxiRideAndFinish(search)
    }
    
    private func formatLocation(location: MileusWatchdogLocation) -> String {
        return "{'lat': \(location.latitude), 'lon': \(location.longitude), 'address_line_1': '\(inputSanitizer.sanitizeJS(location.address?.firstLine ?? ""))', 'address_line_2': '\(inputSanitizer.sanitizeJS(location.address?.secondLine ?? ""))', 'accuracy': \(location.accuracy)}"
    }
    
    private func startLocationScanning() {
        if mileusWatchdogLocationSync == nil {
            mileusWatchdogLocationSync = try? MileusWatchdogLocationSync()
        }
        mileusWatchdogLocationSync?.start(completion: { [weak self] in
            self?.mileusWatchdogLocationSync = nil
        })
    }
    
}
