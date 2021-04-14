
import Foundation


struct LocationScanningMessage: WebViewMessage {
    
    let identifier = "startLocationScanning"
    
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func canHandle(name: String) -> Bool {
        name == identifier
    }
    
    func execute(data: Any) -> Bool {
        action()
        return true
    }
    
}
