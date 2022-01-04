
import Foundation
import MessageUI

internal final class SMSHandler: NSObject, MFMessageComposeViewControllerDelegate {
    
    weak var presenter: UIViewController?
    var completionHandler: ()->()
    
    init(presenter: UIViewController?, completionHandler: @escaping ()->()) {
        self.presenter = presenter
        self.completionHandler = completionHandler
    }
    
    internal func sendSMS(to number: String, with body: String) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = body
        messageVC.recipients = [number]
        messageVC.messageComposeDelegate = self
        presenter?.present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        completionHandler()
    }
}
