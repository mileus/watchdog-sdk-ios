
import Foundation
import WebKit


protocol WebViewMessage {
    var identifier: String { get }
    
    func canHandle(name: String) -> Bool
    func execute(data: Any) -> Bool
}
