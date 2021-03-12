
import UIKit


class SearchVC: UIViewController {

    var viewModel: SearchVM!
    
    private var contentView: SearchView {
        return view as! SearchView
    }
    
    private var navigationControllerMessageHandler: NavigationControllerMessagesHandler?
    
    deinit {
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("watchdog_search_title", tableName: "Localizable", bundle: Bundle.bundle(for: SearchVC.self), value: "", comment: "")
        configure()
        bind()
    }
    
    private func configure() {
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonPressed(sender:)))
        navigationItem.leftBarButtonItem = closeBarButton
        contentView.navigationItem = navigationItem
        
        contentView.offlineView.tryAgainButton.addTarget(self, action: #selector(tryAgainButtonPressed), for: .touchUpInside)
        
        navigationControllerMessageHandler = NavigationControllerMessagesHandler(
            delegate: navigationController as? NavigationBarWebDelegate
        )
        contentView.setupWebView(messages: viewModel.messages + navigationControllerMessageHandler!.getMessages())
        navigationControllerMessageHandler?.webView = contentView.webView
    }
    
    private func bind() {
        contentView.load(url: viewModel.getURL())
        viewModel.updateCoordinates = { [weak self] in
            guard let self = self else { return }
            if let origin = self.viewModel.getOrigin() {
                self.contentView.updateOrigin(location: origin)
            }
            if let destination = self.viewModel.getDestination() {
                self.contentView.updateDestination(location: destination)
            }
            if let home = self.viewModel.getHome() {
                self.contentView.updateHome(location: home)
            }
        }
    }
    
    @objc
    private func closeButtonPressed(sender: AnyObject) {
        viewModel.didFinish()
    }
    
    @objc
    private func tryAgainButtonPressed() {
        contentView.resetWebView()
        contentView.load(url: viewModel.getURL())
    }

}
