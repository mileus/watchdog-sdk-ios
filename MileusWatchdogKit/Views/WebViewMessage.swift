
import Foundation
import WebKit


protocol WebViewMessage {
    var identifier: String { get }
    
    func handle(message: WKScriptMessage) -> Bool
}
