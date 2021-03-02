
import Foundation


struct InfoIconVisibilityMessage: WebViewMessage {
    
    let identifier = "setInfoIconVisible"
    
    private let action: (Bool) -> Void
    
    init(action: @escaping (Bool) -> Void) {
        self.action = action
    }
    
    func canHandle(name: String) -> Bool {
        name == identifier
    }
    
    func execute(data: Any) -> Bool {
        action(data as? Bool ?? false)
        return true
    }
    
}
