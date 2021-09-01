
import UIKit

class FormView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var accessTokenTextField: UITextField!
    @IBOutlet weak var partnerNameTextField: UITextField!
    @IBOutlet weak var originLocationView: FormLocationView!
    @IBOutlet weak var destinationLocationView: FormLocationView!
    @IBOutlet weak var homeLocationView: FormLocationView!
    @IBOutlet weak var environmentPickerView: UIPickerView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var validationButton: UIButton!
    @IBOutlet weak var schedulerButton: UIButton!
    @IBOutlet weak var oneTimeSearchButton: UIButton!
    @IBOutlet weak var explanationKey: TextField!
    
    var environments: [String] = [] {
        didSet {
            environmentPickerView.reloadAllComponents()
        }
    }
    
    private lazy var textFields: [UITextField] = {
        [
            accessTokenTextField, partnerNameTextField
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
        originLocationView.setPlaceholderPrefix(prefix: "Origin")
        destinationLocationView.setPlaceholderPrefix(prefix: "Destination")
        homeLocationView.setPlaceholderPrefix(prefix: "Home")
    }
    
    private func setupButtonTitles() {
        searchButton.setTitle(NSLocalizedString("Watchdog", comment: ""), for: .normal)
        validationButton.setTitle(NSLocalizedString("Market Validation", comment: ""), for: .normal)
        schedulerButton.setTitle(NSLocalizedString("Scheduler", comment: ""), for: .normal)
        oneTimeSearchButton.setTitle(NSLocalizedString("One time search", comment: ""), for: .normal)
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
