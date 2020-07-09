
import UIKit


class SearchVC: UIViewController {

    var viewModel: SearchVM!
    
    private var contentView: SearchView {
        return view as! SearchView
    }
    
    deinit {
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonPressed(sender:)))
        navigationItem.leftBarButtonItem = closeBarButton
        
        contentView.offlineView.tryAgainButton.addTarget(self, action: #selector(tryAgainButtonPressed), for: .touchUpInside)
        
        contentView.setupWebView(delegate: viewModel)
    }
    
    private func bind() {
        contentView.load(url: viewModel.getURL())
        viewModel.updateCoordinates = { [unowned self] in
            if let origin = self.viewModel.getOrigin() {
                self.contentView.updateOrigin(location: origin)
            }
            if let destination = self.viewModel.getDestination() {
                self.contentView.updateDestination(location: destination)
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