
import Foundation

struct FinishFlowMessageWithError: WebViewMessage {
    
    let identifier = "finishFlowWithError"
    
    private let action: (MileusFlowError) -> Void
    
    init(action: @escaping (MileusFlowError) -> Void) {
        self.action = action
    }
    
    func canHandle(name: String) -> Bool {
        name == identifier
    }
    
    func execute(data: Any) -> Bool {
        guard let message = data as? String else {
            return false
        }
        action(.invalidState(message: message))
        return true
    }
}
