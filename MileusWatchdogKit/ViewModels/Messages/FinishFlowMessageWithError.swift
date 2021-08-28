
import Foundation

struct FinishFlowMessageWithError: WebViewMessage {
    
    let identifier = "finishFlowWithError"
    
    private let action: (MileusWatchdogError) -> Void
    
    init(action: @escaping (MileusWatchdogError) -> Void) {
        self.action = action
    }
    
    func canHandle(name: String) -> Bool {
        name == identifier
    }
    
    func execute(data: Any) -> Bool {
        guard let message = data as? String else {
            return false
        }
        action(.fatalInvalidState(message: message))
        return true
    }
}
