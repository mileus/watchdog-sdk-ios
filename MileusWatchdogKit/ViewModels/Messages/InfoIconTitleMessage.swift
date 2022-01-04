
import Foundation

fileprivate struct InfoIconTitleMessageData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
    
    let title: String?
}

struct InfoIconTitleMessage: WebViewMessage {
    
    let identifier = "setToolbarTitle"
    
    private let action: (String?) -> Void
    
    init(action: @escaping (String?) -> Void) {
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
        guard let response = try? JSONDecoder().decode(InfoIconTitleMessageData.self, from: binaryData) else {
            return false
        }
       
        guard let title = response.title else {
            return false
        }
        action(title)
        return true
    }
    
}
