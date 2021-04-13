
import UIKit
import MileusWatchdogKit
import CoreLocation


final class FormVC: UIViewController {

    private let viewModel = FormVM()
    
    private var mileusVC: UINavigationController?
    
    private let locationManager = CLLocationManager()
    private lazy var notificationService: NotificationsService = {
        LocalNotificationsService(delegate: self)
    }()
    
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
        locationManager.requestAlwaysAuthorization()
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
        map(location: viewModel.originLocation, to: contentView.originLocationView)
        map(location: viewModel.destinationLocation, to: contentView.destinationLocationView)
        map(location: viewModel.homeLocation, to: contentView.homeLocationView)
        contentView.environments = viewModel.environments
        contentView.environmentPickerView.selectRow(viewModel.selectedEnvironmentIndex, inComponent: 0, animated: false)
    }
    
    private func map(location: FormLocation, to locationView: FormLocationView) {
        locationView.addressFirstLineTextField.text = location.addressFirstLine
        locationView.addressSecondLineTextField.text = location.addressSecondLine
        locationView.latitudeTextField.text = location.latitude
        locationView.longitudeTextField.text = location.longitude
    }
    
    private func update() {
        viewModel.accessToken = contentView.accessTokenTextField.text ?? ""
        viewModel.partnerName = contentView.partnerNameTextField.text
        map(locationView: contentView.originLocationView, to: viewModel.originLocation)
        map(locationView: contentView.destinationLocationView, to: viewModel.destinationLocation)
        map(locationView: contentView.homeLocationView, to: viewModel.homeLocation)
        viewModel.selectedEnvironmentIndex = contentView.environmentPickerView.selectedRow(inComponent: 0)
    }
    
    private func map(locationView: FormLocationView, to location: FormLocation) {
        location.addressFirstLine = locationView.addressFirstLineTextField.text
        location.addressSecondLine = locationView.addressSecondLineTextField.text
        location.latitude = locationView.latitudeTextField.text
        location.longitude = locationView.longitudeTextField.text
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
        askForNotificationPermission { [weak self] in
            self?.minimizeAndFireLocationScanningLocalNotification()
        }
        
    }
    
    private func askForNotificationPermission(success: @escaping () -> Void) {
        notificationService.requestPermission { (granted) in
            if granted {
                DispatchQueue.main.async {
                    success()
                }
            }
        }
    }
    
    private func minimizeAndFireLocationScanningLocalNotification() {
        minimizeApp()
        fireLocationScanningLocalNotification()
    }
    
    private func minimizeApp() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    private func fireLocationScanningLocalNotification() {
        notificationService.showBackgroundSyncNotification()
    }
    
    private func startBackgroundLocationScanning() {
        update()
        contentView.locationButton.isEnabled = false
        viewModel.locationSync(completion: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.contentView.locationButton.isEnabled = true
                self?.showAlert(message: "Location Sync Completed.")
            }
        })
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
    
    func mileus(_ mileus: MileusWatchdogScheduler, showSearch data: MileusWatchdogSearchData) {
        viewModel.searchData = data
        showLocationVC(data: data)
    }
    
}


extension FormVC: LocationFormDelegate {
    
    func locationForm(_ locationForm: LocationFormVM, didFinish location: MileusWatchdogLocation) {
        viewModel.updateLocation(location: location)
        mileusVC?.dismiss(animated: true, completion: nil)
    }
    
}

extension FormVC: LocalNotificationsServiceDelegate {
    func notificationServiceStartBackgroundSync() {
        startBackgroundLocationScanning()
    }
}
