
import WebKit


final class WebView: WKWebView {
    
    init(messagesDelegate: WebViewMessagesDelegate?) {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        let delegate = WebViewMessagesHandler(messagesDelegate: messagesDelegate)
        
        super.init(frame: .zero, configuration: config)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
