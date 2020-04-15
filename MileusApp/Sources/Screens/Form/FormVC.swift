
import UIKit
import MileusKit


class FormVC: UIViewController {

    private let viewModel = FormVM()
    
    private var mileusVC: UIViewController?
    
    private var contentView: FormView {
        return view as! FormView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
        contentView.searchButton.addTarget(self, action: #selector(searchButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func bind() {
        contentView.accessTokenTextField.text = viewModel.accessToken
        contentView.originAddressTextField.text = viewModel.originAddress
        contentView.originLatitudeTextField.text = viewModel.originLatitude
        contentView.originLongitudeTextField.text = viewModel.originLongitude
        contentView.destinationAddressTextField.text = viewModel.destinationAddress
        contentView.destinationLatitudeTextField.text = viewModel.destinationLatitude
        contentView.destinationLongitudeTextField.text = viewModel.destinationLongitude
    }
    
    @objc
    private func searchButtonPressed(sender: AnyObject) {
        viewModel.accessToken = contentView.accessTokenTextField.text ?? ""
        viewModel.originAddress = contentView.originAddressTextField.text
        viewModel.originLatitude = contentView.originLatitudeTextField.text
        viewModel.originLongitude = contentView.originLongitudeTextField.text
        viewModel.destinationAddress = contentView.destinationAddressTextField.text
        viewModel.destinationLatitude = contentView.destinationLatitudeTextField.text
        viewModel.destinationLongitude = contentView.destinationLongitudeTextField.text
        
        mileusVC = viewModel.search(from: self, delegate: self)
    }

}

extension FormVC: MileusSearchFlowDelegate {
    
    func mileus(_ mileus: MileusSearch, showSearch data: MileusSearchData) {
        debugPrint("mileusShowSearch")
        showAlert(message: "Show Search")
    }
    
    func mileusShowTaxiRide(_ mileus: MileusSearch) {
        debugPrint("mileusShowTaxiRide")
        showAlert(message: "Show Taxi Ride")
    }
    
    func mileusDidFinish(_ mileus: MileusSearch) {
        mileusVC?.dismiss(animated: true, completion: nil)
        mileusVC = nil
        viewModel.mileusSearch = nil
    }
    
    private func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Action", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
}
