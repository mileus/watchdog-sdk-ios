
import UIKit

class LocationFormView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var addressFirstLineTextField: UITextField!
    @IBOutlet weak var addressSecondLineTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    private lazy var textFields = [
        addressFirstLineTextField, addressSecondLineTextField, latitudeTextField, longitudeTextField
    ]
    
    private var keyboardManager: KeyboardManager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        keyboardManager = KeyboardManager(scrollView: scrollView)
        
        addressFirstLineTextField.placeholder = NSLocalizedString("Address (Street and number)", comment: "")
        addressSecondLineTextField.placeholder = NSLocalizedString("Address Optinal (City, country, code)", comment: "")
        latitudeTextField.placeholder = NSLocalizedString("Latitude", comment: "")
        longitudeTextField.placeholder = NSLocalizedString("Longitude", comment: "")
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureSelected(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func tapGestureSelected(sender: AnyObject) {
        textFields.forEach { (textField) in
            textField?.resignFirstResponder()
        }
    }

}
