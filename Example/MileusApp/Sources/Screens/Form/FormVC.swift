
import UIKit
import MileusWatchdogKit
import CoreLocation


class FormVC: UIViewController {

    private let viewModel = FormVM()
    
    private var mileusVC: UIViewController?
    
    private let locationManager = CLLocationManager()
    
    private var contentView: FormView {
        return view as! FormView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func configure() {
        contentView.searchButton.addTarget(self, action: #selector(searchButtonPressed(sender:)), for: .touchUpInside)
        contentView.validationButton.addTarget(self, action: #selector(validationButtonPressed(sender:)), for: .touchUpInside)
        contentView.schedulerButton.addTarget(self, action: #selector(schedulerButtonPressed(sender:)), for: .touchUpInside)
        contentView.locationButton.addTarget(self, action: #selector(locationButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func bind() {
        contentView.accessTokenTextField.text = viewModel.accessToken
        contentView.partnerNameTextField.text = viewModel.partnerName
        contentView.originAddressFirstLineTextField.text = viewModel.originAddressFirstLine
        contentView.originAddressSecondLineTextField.text = viewModel.originAddressSecondLine
        contentView.originLatitudeTextField.text = viewModel.originLatitude
        contentView.originLongitudeTextField.text = viewModel.originLongitude
        contentView.destinationAddressFirstLineTextField.text = viewModel.destinationAddressFirstLine
        contentView.destinationAddressSecondLineTextField.text = viewModel.destinationAddressSecondLine
        contentView.destinationLatitudeTextField.text = viewModel.destinationLatitude
        contentView.destinationLongitudeTextField.text = viewModel.destinationLongitude
        contentView.environments = viewModel.environments
        contentView.environmentPickerView.selectRow(viewModel.selectedEnvironmentIndex, inComponent: 0, animated: false)
    }
    
    private func update() {
        viewModel.accessToken = contentView.accessTokenTextField.text ?? ""
        viewModel.partnerName = contentView.partnerNameTextField.text
        viewModel.originAddressFirstLine = contentView.originAddressFirstLineTextField.text
        viewModel.originAddressSecondLine = contentView.originAddressSecondLineTextField.text
        viewModel.originLatitude = contentView.originLatitudeTextField.text
        viewModel.originLongitude = contentView.originLongitudeTextField.text
        viewModel.destinationAddressFirstLine = contentView.destinationAddressFirstLineTextField.text
        viewModel.destinationAddressSecondLine = contentView.destinationAddressSecondLineTextField.text
        viewModel.destinationLatitude = contentView.destinationLatitudeTextField.text
        viewModel.destinationLongitude = contentView.destinationLongitudeTextField.text
        viewModel.selectedEnvironmentIndex = contentView.environmentPickerView.selectedRow(inComponent: 0)
    }
    
    @objc
    private func searchButtonPressed(sender: AnyObject) {
        update()
        mileusVC = viewModel.search(delegate: self).show(from: self)
    }
    
    @objc
    private func validationButtonPressed(sender: AnyObject) {
        update()
        mileusVC = viewModel.validation(delegate: self).show(from: self)
    }
    
    @objc
    private func schedulerButtonPressed(sender: AnyObject) {
        update()
        mileusVC = viewModel.scheduler(delegate: self).show(from: self)
    }
    
    @objc
    private func locationButtonPressed(sender: AnyObject) {
        contentView.locationButton.isEnabled = false
        viewModel.locationSync(completion: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.contentView.locationButton.isEnabled = true
                self?.showAlert(message: "Location Sync Completed.")
            }
        })
    }
    
    private func showAlert(title: String = "Success", message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        }))
        show(alertController, sender: self)
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
        viewModel.mileusWatchdogScheduler = nil
    }
    
}


extension FormVC: MileusMarketValidationFlowDelegate {
    
    func mileusDidFinish(_ mileus: MileusMarketValidation) {
        closeMileus(completion: nil)
    }
    
}


extension FormVC: MileusWatchdogSchedulerFlowDelegate {
    
    func mileusDidFinish(_ mileus: MileusWatchdogScheduler) {
        closeMileus(completion: nil)
    }
    
}


extension FormVC: LocationFormDelegate {
    
    func locationForm(_ locationForm: LocationFormVM, didFinish location: MileusWatchdogLocation) {
        viewModel.updateLocation(location: location)
        mileusVC?.dismiss(animated: true, completion: nil)
    }
    
}
