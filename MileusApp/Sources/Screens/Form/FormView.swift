
import UIKit


class FormView: UIView {

    @IBOutlet weak var accessTokenTextField: UITextField!
    @IBOutlet weak var originAddressTextField: UITextField!
    @IBOutlet weak var originLatitudeTextField: UITextField!
    @IBOutlet weak var originLongitudeTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var destinationLatitudeTextField: UITextField!
    @IBOutlet weak var destinationLongitudeTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        accessTokenTextField.placeholder = "Access Token"
        originAddressTextField.placeholder = "Origin Address"
        originLatitudeTextField.placeholder = "Origin Latitude"
        originLongitudeTextField.placeholder = "Origin Longitude"
        destinationAddressTextField.placeholder = "Destination Address"
        destinationLatitudeTextField.placeholder = "Destination Latitude"
        destinationLongitudeTextField.placeholder = "Destinatino Longitude"
        
        originLatitudeTextField.keyboardType = .decimalPad
        originLongitudeTextField.keyboardType = .decimalPad
        destinationLatitudeTextField.keyboardType = .decimalPad
        destinationLongitudeTextField.keyboardType = .decimalPad
        
#if DEBUG
        accessTokenTextField.text = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaSI6MTIzNDUsInBuIjoiZHVtbXktcGFydG5lciIsInBlaSI6ImV4dGVybmFsLXBhc3Nlbmdlci1pZCIsImlhdCI6MTU4NTE0MTAwNn0.0vyb_yjUH4RQ1lyhSiao3h6JdJagQBy_QZXyPWRr9NU"
#endif
        originAddressTextField.text = "Prague - Nové Město"
        originLatitudeTextField.text = "50.091266"
        originLongitudeTextField.text = "14.438927"
        destinationAddressTextField.text = "Holešovice"
        destinationLatitudeTextField.text = "50.121765629793295"
        destinationLongitudeTextField.text = "14.489431312606477"
        
        searchButton.setTitle("Search", for: .normal)
        
        accessTokenTextField.returnKeyType = .done
        originAddressTextField.returnKeyType = .done
        originLatitudeTextField.returnKeyType = .done
        originLongitudeTextField.returnKeyType = .done
        destinationAddressTextField.returnKeyType = .done
        destinationLatitudeTextField.returnKeyType = .done
        destinationLongitudeTextField.returnKeyType = .done
        
        accessTokenTextField.delegate = self
        originAddressTextField.delegate = self
        originLatitudeTextField.delegate = self
        originLongitudeTextField.delegate = self
        destinationAddressTextField.delegate = self
        destinationLatitudeTextField.delegate = self
        destinationLongitudeTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureSelected(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func tapGestureSelected(sender: AnyObject) {
        originAddressTextField.resignFirstResponder()
        originLatitudeTextField.resignFirstResponder()
        originLongitudeTextField.resignFirstResponder()
        destinationAddressTextField.resignFirstResponder()
        destinationLatitudeTextField.resignFirstResponder()
        destinationLongitudeTextField.resignFirstResponder()
    }

}

extension FormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
