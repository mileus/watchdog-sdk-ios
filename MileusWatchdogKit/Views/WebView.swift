
import WebKit


final class WebView: WKWebView {
    
    init(messages: [WebViewMessage]) {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        let delegate = WebViewMessagesHandler(
            messages: messages,
            content: contentController
        )
        
        super.init(frame: .zero, configuration: config)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
