
import UIKit


class MainNC: UINavigationController {
    
    private var infoButtonViewModel: InfoButtonViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    deinit {
        debugPrint("DEINIT: \(String(describing: self))")
    }

}


extension MainNC: NavigationBarWebDelegate {
    
    private var currentItem: UINavigationItem {
        viewControllers.first?.navigationItem ?? navigationItem
    }
    
    func setTitle(title: String?) {
        currentItem.title = title
    }
    
    func setInfoButton(viewModel: InfoButtonViewModel?) {
        infoButtonViewModel = viewModel
        if let _ = infoButtonViewModel {
            let infoButton = UIButton(type: .infoLight)
            infoButton.addTarget(self,
                                 action: #selector(infoButtonPressed(sender:)),
                                 for: .touchUpInside
            )
            currentItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        } else {
            currentItem.rightBarButtonItem = nil
        }
    }
    
    @objc
    private func infoButtonPressed(sender: AnyObject) {
        infoButtonViewModel?.action()
    }
}
