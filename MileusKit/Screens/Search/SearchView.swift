
import UIKit
import WebKit


class SearchView: UIView {
    
    enum WebViewJSConstants {
        static let openSearch = "openSearchScreen"
        static let openTaxiRide = "openTaxiRideScreen"
    }

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    private(set) var webView: WKWebView!
    
    deinit {
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadingView.hidesWhenStopped = true
        loadingView.color = .darkGray
    }
    
    func load(url: URL) {
        loadingView.startAnimating()
        webView.load(URLRequest(url: url))
    }
    
    func updateOrigin(location: String) {
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript("window.setOrigin(\(location));", completionHandler: nil)
        }
    }
    
    func updateDestination(location: String) {
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript("window.setDestination(\(location));", completionHandler: nil)
        }
    }
     
    func setupWebView(delegate: WKScriptMessageHandler) {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        contentController.add(delegate, name: WebViewJSConstants.openSearch)
        contentController.add(delegate, name: WebViewJSConstants.openTaxiRide)
        
        webView = WKWebView(frame: .zero, configuration: config)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        webView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        
        insertSubview(loadingView, aboveSubview: webView)
    }

}

extension SearchView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(navigationAction.request.url?.absoluteString.hasPrefix(MileusKit.environment.url) ?? false ? .allow : .cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView.stopAnimating()
    }
    
}
