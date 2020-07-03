
import UIKit


class FormView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var accessTokenTextField: UITextField!
    @IBOutlet weak var originAddressTextField: UITextField!
    @IBOutlet weak var originLatitudeTextField: UITextField!
    @IBOutlet weak var originLongitudeTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var destinationLatitudeTextField: UITextField!
    @IBOutlet weak var destinationLongitudeTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var validationButton: UIButton!
    
    private lazy var textFields: [UITextField] = {
        [
            accessTokenTextField, originAddressTextField,
            originLatitudeTextField, originLongitudeTextField,
            destinationAddressTextField, destinationLatitudeTextField,
            destinationLongitudeTextField
        ]
    }()
    
    private var keyboardManager: KeyboardManager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        keyboardManager = KeyboardManager(scrollView: scrollView)
        
        accessTokenTextField.placeholder = NSLocalizedString("Access Token", comment: "")
        originAddressTextField.placeholder = NSLocalizedString("Origin Address", comment: "")
        originLatitudeTextField.placeholder = NSLocalizedString("Origin Latitude", comment: "")
        originLongitudeTextField.placeholder = NSLocalizedString("Origin Longitude", comment: "")
        destinationAddressTextField.placeholder = NSLocalizedString("Destination Address", comment: "")
        destinationLatitudeTextField.placeholder = NSLocalizedString("Destination Latitude", comment: "")
        destinationLongitudeTextField.placeholder = NSLocalizedString("Destination Longitude", comment: "")
        searchButton.setTitle(NSLocalizedString("Search", comment: ""), for: .normal)
        validationButton.setTitle(NSLocalizedString("Market Validation", comment: ""), for: .normal)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureSelected(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func tapGestureSelected(sender: AnyObject) {
        textFields.forEach { (textField) in
            textField.resignFirstResponder()
        }
    }

}
