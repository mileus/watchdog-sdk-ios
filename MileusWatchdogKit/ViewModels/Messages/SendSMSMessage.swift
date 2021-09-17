
import Foundation

fileprivate struct SendSMSMessageData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case number = "phone_number"
        case body = "body_text"
    }
    
    let number: String?
    let body: String?
}

struct SendSMSMessage: WebViewMessage {
    
    let identifier = "getSmsTicket"
    
    private let action: (_ phone: String,_  body: String) -> Void
    
    init(action: @escaping (_ phone: String,_  body: String) -> Void) {
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
        guard let response = try? JSONDecoder().decode(SendSMSMessageData.self, from: binaryData) else {
            return false
        }
       
        guard let number = response.number, let body = response.body else {
            return false
        }
        action(number, body)
        return true
    }
}
