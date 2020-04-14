
import UIKit


class KeyboardManager {
    
    var heightChanged: ((CGFloat) -> Void)?
    
    private(set) var height: CGFloat = 0.0 {
        didSet {
            heightChanged?(height)
        }
    }
    
    private var userInfo: [AnyHashable : Any]?
    
    private weak var scrollView: UIScrollView?
    
    init(scrollView: UIScrollView? = nil) {
        self.scrollView = scrollView
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else {
            return
        }
        userInfo = notification.userInfo
        height = frame.height
        scrollView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: frame.height, right: 0.0)
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        /*guard let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else {
            return
        }*/
        userInfo = notification.userInfo
        height = 0.0
        scrollView?.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
