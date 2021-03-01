
import WebKit


protocol WebViewMessagesDelegate {
    func openSearch(data: [String : String])
    func openTaxiRide()
    func openTaxiRideAndFinish()
    func didFinish()
}

final class WebViewMessagesHandler: NSObject {
    
    private enum WebViewJSMessage: String {
        case openSearch = "openSearchScreen"
        case openTaxiRide = "openTaxiRideScreen"
        case openTaxiRideAndFinish = "openTaxiRideScreenAndFinish"
        case marketValidationDidFinish = "finishMarketValidation"
    }
    
    var messagesDelegate: WebViewMessagesDelegate?
    
    init(messagesDelegate: WebViewMessagesDelegate?, content: WKUserContentController) {
        self.messagesDelegate = messagesDelegate
        
        super.init()
        
        let delegate = self
        content.add(delegate, name: WebViewJSMessage.openSearch.rawValue)
        content.add(delegate, name: WebViewJSMessage.openTaxiRide.rawValue)
        content.add(delegate, name: WebViewJSMessage.openTaxiRideAndFinish.rawValue)
        content.add(delegate, name: WebViewJSMessage.marketValidationDidFinish.rawValue)
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
        if message.name == WebViewMessagesHandler.WebViewJSConstants.openSearch {
            handleSearch(message: message)
        } else if message.name == WebViewMessagesHandler.WebViewJSConstants.openTaxiRide {
            handleOpenTaxiRide()
        } else if message.name == WebViewMessagesHandler.WebViewJSConstants.openTaxiRideAndFinish {
            handleOpenTaxiRideAndFinish()
        } else if message.name == WebViewMessagesHandler.WebViewJSConstants.marketValidationDidFinish {
            handleDidFinish()
        }
    }
    
    private func handleSearch(message: WKScriptMessage) {
        guard let jsonString = message.body as? String else {
            return
        }
        guard let data = jsonString.data(using: .utf8) else {
            return
        }
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else {
            return
        }
        messagesDelegate?.openSearch(data: dic)
    }
    
    private func handleOpenTaxiRide() {
        messagesDelegate?.openTaxiRide()
    }
    
    private func handleOpenTaxiRideAndFinish() {
        messagesDelegate?.openTaxiRideAndFinish()
    }
    
    private func handleDidFinish() {
        messagesDelegate?.didFinish()
    }
    
    @inline(__always)
    private func isNotMainThread() -> Bool {
        !Thread.isMainThread
    }
}
