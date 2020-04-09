
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
    }
    
    func load(url: URL) {
        loadingView.startAnimating()
        webView.load(URLRequest(url: url))
    }
    
    func updateOrigin(location: MileusLocation) {
        DispatchQueue.main.async {
            let data = "{'lat': \(location.latitude), 'lon': \(location.longitude), 'address': '\(location.address)', 'accuracy': \(location.accuracy)}"
            self.webView.evaluateJavaScript("window.setOrigin(\(data));", completionHandler: { data, error in
                print(data)
                print(error)
            })
        }
    }
    
    func updateDestination(location: MileusLocation) {
        DispatchQueue.main.async {
            let data: [String : Any] = ["lat": location.latitude, "lon": location.longitude, "address": location.address, "accuracy": location.accuracy]
            self.webView.evaluateJavaScript("window.setDestination(\(data));", completionHandler: nil)
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
        webView.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1.0).isActive = true
        webView.leftAnchor.constraint(equalToSystemSpacingAfter: self.leftAnchor, multiplier: 1.0).isActive = true
        webView.rightAnchor.constraint(equalToSystemSpacingAfter: self.rightAnchor, multiplier: 1.0).isActive = true
        webView.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 1.0).isActive = true
        
        webView.backgroundColor = UIColor.white
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
