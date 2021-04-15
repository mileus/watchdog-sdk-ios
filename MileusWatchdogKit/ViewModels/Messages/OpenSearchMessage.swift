
import Foundation


fileprivate struct OpenSearchMessageData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case type = "search_type"
        case addressFirstLine = "current_address_line_1"
        case addressSecondLine = "current_address_line_2"
        case longitude = "current_longitude"
        case latitude = "current_latitude"
    }
    
    let type: String?
    let addressFirstLine: String?
    let addressSecondLine: String?
    let longitude: String?
    let latitude: String?
}



struct OpenSearchMessage: WebViewMessage {
    
    let identifier = "openSearchScreen"
    
    private let action: (MileusWatchdogLabeledLocation) -> Void
    
    init(action: @escaping (MileusWatchdogLabeledLocation) -> Void) {
        self.action = action
    }
    
    func canHandle(name: String) -> Bool {
        name == identifier
    }
    
    func execute(data: Any) -> Bool {
        guard let jsonString = data as? String else {
            return false
        }
        guard let binaryData = jsonString.data(using: .utf8) else {
            return false
        }
        guard let response = try? JSONDecoder().decode(OpenSearchMessageData.self, from: binaryData) else {
            return false
        }
        guard let model = map(response: response) else {
            return false
        }
        action(model)
        return true
    }
    
    private func map(response: OpenSearchMessageData) -> MileusWatchdogLabeledLocation? {
        guard let safeType = response.type, let type = MileusWatchdogLocationType(rawValue: safeType) else {
            return nil
        }
        return MileusWatchdogLabeledLocation(
            label: type,
            data: .init(
                address: response.addressFirstLine == nil ? nil : .init(
                    firstLine: response.addressFirstLine!,
                    secondLine: response.addressSecondLine
                ),
                latitude: Double(response.latitude ?? "0.0") ?? 0.0,
                longitude: Double(response.longitude ?? "0.0") ?? 0.0
            )
        )
    }
    
}
