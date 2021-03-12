
import UIKit


final class FormLocationView: UIView {
    let titleLabel = UILabel()
    let addressFirstLineTextField = TextField()
    let addressSecondLineTextField = TextField()
    let latitudeTextField = TextField()
    let longitudeTextField = TextField()
    
    private var textFields: [UITextField] {
        [
            addressFirstLineTextField, addressSecondLineTextField,
            latitudeTextField, longitudeTextField
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStack()
        setupTextFields()
    }
    
    func setPlaceholderPrefix(prefix: String) {
        titleLabel.text = NSLocalizedString("\(prefix) Location", comment: "")
        addressFirstLineTextField.placeholder = NSLocalizedString("\(prefix) Address (Street and number)", comment: "")
        addressSecondLineTextField.placeholder = NSLocalizedString("\(prefix) Address Optinal (City, country, code)", comment: "")
        latitudeTextField.placeholder = NSLocalizedString("\(prefix) Latitude", comment: "")
        longitudeTextField.placeholder = NSLocalizedString("\(prefix) Longitude", comment: "")
    }
    
    private func setupTextFields() {
        textFields.forEach { textField in
            textField.borderStyle = .roundedRect
            textField.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        }
    }
    
    private func setupStack() {
        let verticalStack = UIStackView(arrangedSubviews: [
            titleLabel, addressFirstLineTextField,
            addressSecondLineTextField, latitudeTextField,
            longitudeTextField
        ])
        verticalStack.distribution = .fillEqually
        verticalStack.alignment = .fill
        verticalStack.axis = .vertical
        verticalStack.spacing = 20.0
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStack)
        
        leftAnchor.constraint(equalTo: verticalStack.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: verticalStack.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: verticalStack.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: verticalStack.topAnchor).isActive = true
    }
}
