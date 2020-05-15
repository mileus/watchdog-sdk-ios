
import UIKit

class LocationFormVC: UIViewController {

    var viewModel: LocationFormVM!
    
    private var contentView: LocationFormView {
        return view as! LocationFormView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
        contentView.doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    private func bind() {
        contentView.addressTextField.text = viewModel.address
        contentView.latitudeTextField.text = viewModel.latitude
        contentView.longitudeTextField.text = viewModel.longitude
    }
    
    @objc
    private func doneButtonPressed(sender: AnyObject) {
        viewModel.address = contentView.addressTextField.text
        viewModel.latitude = contentView.latitudeTextField.text
        viewModel.longitude = contentView.longitudeTextField.text
        
        viewModel.save()
    }

}
