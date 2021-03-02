
import UIKit


class FormView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var accessTokenTextField: UITextField!
    @IBOutlet weak var partnerNameTextField: UITextField!
    @IBOutlet weak var originAddressTextField: UITextField!
    @IBOutlet weak var originLatitudeTextField: UITextField!
    @IBOutlet weak var originLongitudeTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var destinationLatitudeTextField: UITextField!
    @IBOutlet weak var destinationLongitudeTextField: UITextField!
    @IBOutlet weak var environmentPickerView: UIPickerView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var validationButton: UIButton!
    @IBOutlet weak var schedulerButton: UIButton!
    
    var environments: [String] = [] {
        didSet {
            environmentPickerView.reloadAllComponents()
        }
    }
    
    private lazy var textFields: [UITextField] = {
        [
            accessTokenTextField, partnerNameTextField,
            originAddressTextField, originLatitudeTextField,
            originLongitudeTextField, destinationAddressTextField,
            destinationLatitudeTextField, destinationLongitudeTextField
        ]
    }()
    
    private var keyboardManager: KeyboardManager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        keyboardManager = KeyboardManager(scrollView: scrollView)
        
        setupTextFieldPlaceholders()
        setupButtonTitles()
        setupEnvironmentPicker()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureSelected(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupTextFieldPlaceholders() {
        accessTokenTextField.placeholder = NSLocalizedString("Access Token", comment: "")
        partnerNameTextField.placeholder = NSLocalizedString("Partner Name", comment: "")
        originAddressTextField.placeholder = NSLocalizedString("Origin Address", comment: "")
        originLatitudeTextField.placeholder = NSLocalizedString("Origin Latitude", comment: "")
        originLongitudeTextField.placeholder = NSLocalizedString("Origin Longitude", comment: "")
        destinationAddressTextField.placeholder = NSLocalizedString("Destination Address", comment: "")
        destinationLatitudeTextField.placeholder = NSLocalizedString("Destination Latitude", comment: "")
        destinationLongitudeTextField.placeholder = NSLocalizedString("Destination Longitude", comment: "")
    }
    
    private func setupButtonTitles() {
        searchButton.setTitle(NSLocalizedString("Watchdog", comment: ""), for: .normal)
        validationButton.setTitle(NSLocalizedString("Market Validation", comment: ""), for: .normal)
        schedulerButton.setTitle(NSLocalizedString("Scheduler", comment: ""), for: .normal)
    }
    
    private func setupEnvironmentPicker() {
        environmentPickerView.delegate = self
        environmentPickerView.dataSource = self
    }
    
    @objc
    private func tapGestureSelected(sender: AnyObject) {
        textFields.forEach { (textField) in
            textField.resignFirstResponder()
        }
    }

}


extension FormView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        environments.count
    }
    
}


extension FormView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        environments[row]
    }
    
}
