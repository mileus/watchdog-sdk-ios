
import WebKit

protocol CustomJSWebViewDelegate: AnyObject {
    func jsDidCommitNavigation()
}

final class WebView: WKWebView {
    
    enum WebViewError: Error {
        case dataTypeMismatch
    }
    
    private let messagesHandler: WebViewMessagesHandler
    weak var jsDelegate: CustomJSWebViewDelegate?
    
    init(messages: [WebViewMessage]) {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        messagesHandler = WebViewMessagesHandler(
            messages: messages,
            content: contentController
        )
        super.init(frame: .zero, configuration: config)
    }
    
    func inject(_ injection: WebViewInjection) {
        inject(injection, success: { (data: Void) in return }, failure: nil)
    }
    
    func inject<T>(_ injection: WebViewInjection, success: ((T) -> Void)?, failure: ((Error) -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            self?.evaluateJavaScript(injection.command, completionHandler: { [weak self] (result, error) in
                self?.handleInjectionResult(result: result, error: error, success: success, failure: failure)
            })
        }
    }
    
    private func handleInjectionResult<T>(result: Any?, error: Error?, success: ((T) -> Void)?, failure: ((Error) -> Void)?) {
        if let error = error {
            failure?(error)
        } else {
            if let data = result as? T {
                success?(data)
            } else {
                failure?(WebViewError.dataTypeMismatch)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

