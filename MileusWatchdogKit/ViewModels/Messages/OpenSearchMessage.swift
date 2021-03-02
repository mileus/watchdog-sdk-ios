
import Foundation


struct OpenSearchMessage: WebViewMessage {
    
    let identifier = "openSearchScreen"
    
    private let action: ([String : String]) -> Void
    
    init(action: @escaping ([String : String]) -> Void) {
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
        guard let dic = try? JSONSerialization.jsonObject(with: binaryData, options: []) as? [String : String] else {
            return false
        }
        action(dic)
        return true
    }
    
}
