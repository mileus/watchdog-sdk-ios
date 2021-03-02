
import Foundation


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
        action(data as? String)
        return true
    }
    
}
