
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
        
        configureTextFields()
        
        setTextField(accessTokenTextField, text: "", placeholder: "Access Token")
        setTextField(originAddressTextField, text: "Prague - Nové Město", placeholder: "Origin Address")
        setTextField(originLatitudeTextField, text: "50.091266", placeholder: "Origin Latitude")
        setTextField(originLongitudeTextField, text: "14.438927", placeholder: "Origin Longitude")
        setTextField(destinationAddressTextField, text: "Holešovice", placeholder: "Destination Address")
        setTextField(destinationLatitudeTextField, text: "50.121765629793295", placeholder: "Destination Latitude")
        setTextField(destinationLongitudeTextField, text: "14.489431312606477", placeholder: "Destinatino Longitude")
        
        searchButton.setTitle("Search", for: .normal)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureSelected(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureTextFields() {
        textFields.forEach { (textField) in
            textField.returnKeyType = .done
            textField.delegate = self
        }
        
        originLatitudeTextField.keyboardType = .decimalPad
        originLongitudeTextField.keyboardType = .decimalPad
        destinationLatitudeTextField.keyboardType = .decimalPad
        destinationLongitudeTextField.keyboardType = .decimalPad
    }
    
    private func setTextField(_ textField: UITextField, text: String, placeholder: String) {
        textField.text = text
        textField.placeholder = placeholder
    }
    
    @objc
    private func tapGestureSelected(sender: AnyObject) {
        textFields.forEach { (textField) in
            textField.resignFirstResponder()
        }
    }

}

extension FormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "," || string == ".") && textField.text?.contains(".") ?? false {
            return false
        }
        if string == "," {
            textField.text = textField.text! + "."
            return false
        }
        return true
    }
    
}
