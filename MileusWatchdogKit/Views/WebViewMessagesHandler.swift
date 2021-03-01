
import WebKit


protocol WebViewMessagesDelegate {
    func openSearch(data: [String : String])
    func openTaxiRide()
    func openTaxiRideAndFinish()
    func didFinish()
}

final class WebViewMessagesHandler: NSObject {
    
    private let messages: [WebViewMessage]
    
    init(messages: [WebViewMessage], content: WKUserContentController) {
        self.messages = messages
        super.init()
        
        let delegate = self
        messages.forEach { message in
            content.add(delegate, name: message.identifier)
        }
    }
    
}


extension WebViewMessagesHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if isNotMainThread() {
            DispatchQueue.main.async { [weak self] in
                self?.userContentController(userContentController, didReceive: message)
            }
        }
        handleReceivedMessage(message: message)
    }
    
    private func handleReceivedMessage(message: WKScriptMessage) {
        for localMessage in messages where localMessage.canHandle(name: message.name) {
            _ = localMessage.execute(data: message.body)
        }
    }
    
    @inline(__always)
    private func isNotMainThread() -> Bool {
        !Thread.isMainThread
    }
}
