
import UIKit

class OfflineView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        Bundle.bundle(for: OfflineView.self).loadNibNamed("OfflineView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0.0).isActive = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        titleLabel.text = NSLocalizedString("offline_title", tableName: "Localizable", bundle: Bundle.bundle(for: SearchVC.self), value: "", comment: "")
        subtitleLabel.text = NSLocalizedString("offline_message", tableName: "Localizable", bundle: Bundle.bundle(for: SearchVC.self), value: "", comment: "")
        tryAgainButton.setTitle(NSLocalizedString("try_again_button_title", tableName: "Localizable", bundle: Bundle.bundle(for: SearchVC.self), value: "", comment: ""), for: .normal)
        
        tryAgainButton.layer.borderWidth = 1.0
        tryAgainButton.layer.borderColor = UIColor.systemBlue.cgColor
        tryAgainButton.layer.cornerRadius = 8.0
        
    }

}
