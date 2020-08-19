
import UIKit
import MileusWatchdogKit


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
        contentView.validationButton.addTarget(self, action: #selector(validationButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func bind() {
        contentView.accessTokenTextField.text = viewModel.accessToken
        contentView.partnerNameTextField.text = viewModel.partnerName
        contentView.originAddressTextField.text = viewModel.originAddress
        contentView.originLatitudeTextField.text = viewModel.originLatitude
        contentView.originLongitudeTextField.text = viewModel.originLongitude
        contentView.destinationAddressTextField.text = viewModel.destinationAddress
        contentView.destinationLatitudeTextField.text = viewModel.destinationLatitude
        contentView.destinationLongitudeTextField.text = viewModel.destinationLongitude
        contentView.environments = viewModel.environments
    }
    
    private func update() {
        viewModel.accessToken = contentView.accessTokenTextField.text ?? ""
        viewModel.partnerName = contentView.partnerNameTextField.text
        viewModel.originAddress = contentView.originAddressTextField.text
        viewModel.originLatitude = contentView.originLatitudeTextField.text
        viewModel.originLongitude = contentView.originLongitudeTextField.text
        viewModel.destinationAddress = contentView.destinationAddressTextField.text
        viewModel.destinationLatitude = contentView.destinationLatitudeTextField.text
        viewModel.destinationLongitude = contentView.destinationLongitudeTextField.text
        viewModel.selectedEnvironmentIndex = contentView.environmentPickerView.selectedRow(inComponent: 0)
    }
    
    @objc
    private func searchButtonPressed(sender: AnyObject) {
        update()
        mileusVC = viewModel.search(from: self, delegate: self)
    }
    
    @objc
    private func validationButtonPressed(sender: AnyObject) {
        update()
        mileusVC = viewModel.validation(from: self, delegate: self)
    }

}

extension FormVC: MileusWatchdogSearchFlowDelegate {
    
    func mileus(_ mileus: MileusWatchdogSearch, showSearch data: MileusWatchdogSearchData) {
        viewModel.searchData = data
        showLocationVC(data: data)
    }
    
    func mileusShowTaxiRide(_ mileus: MileusWatchdogSearch) {
        showAlert(message: "Show Taxi Ride")
    }
    
    func mileusShowTaxiRideAndFinish(_ mileus: MileusWatchdogSearch) {
        closeMileus {
            self.mileusShowTaxiRide(mileus)
        }
    }
    
    func mileusDidFinish(_ mileus: MileusWatchdogSearch) {
        closeMileus(completion: nil)
    }
    
    private func showLocationVC(data: MileusWatchdogSearchData) {
        let vc = UIStoryboard(name: "LocationForm", bundle: nil).instantiateInitialViewController() as! LocationFormVC
        vc.viewModel = LocationFormVM(searchData: data, delegate: self)
        mileusVC?.present(vc, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Action", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        (mileusVC ?? self).present(alertVC, animated: true, completion: nil)
    }
    
    fileprivate func closeMileus(completion: (() -> Void)?) {
        mileusVC?.dismiss(animated: true, completion: completion)
        mileusVC = nil
        viewModel.mileusSearch = nil
        viewModel.mileusMarketValidation = nil
    }
    
}


extension FormVC: MileusMarketValidationFlowDelegate {
    
    func mileusDidFinish(_ mileus: MileusMarketValidation) {
        closeMileus(completion: nil)
    }
    
}


extension FormVC: LocationFormDelegate {
    
    func locationForm(_ locationForm: LocationFormVM, didFinish location: MileusWatchdogLocation) {
        viewModel.updateLocation(location: location)
        mileusVC?.dismiss(animated: true, completion: nil)
    }
    
}
