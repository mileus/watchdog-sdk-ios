
import UIKit


class MainNC: UINavigationController {
    
    private var infoButtonViewModel: InfoButtonViewModel?

    deinit {
        debugPrint("DEINIT: \(String(describing: self))")
    }

}


extension MainNC: NavigationBarWebDelegate {
    func setTitle(title: String?) {
        navigationItem.title = title
    }
    
    func setInfoButton(viewModel: InfoButtonViewModel?) {
        infoButtonViewModel = viewModel
        if let _ = infoButtonViewModel {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(infoButtonPressed(sender:))
            )
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc
    private func infoButtonPressed(sender: AnyObject) {
        infoButtonViewModel?.action()
    }
}
