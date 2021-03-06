
import UIKit


class TextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        delegate = self
        returnKeyType = .done
    }

}


extension TextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "," || string == ".") && ((textField.text?.contains(",") ?? false) || (textField.text?.contains(".") ?? false)) {
            return false
        }
        return true
    }
    
}
