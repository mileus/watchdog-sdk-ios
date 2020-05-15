//
//  OfflineView.swift
//  MileusKit
//
//  Created by Libor Polehna on 28/04/2020.
//  Copyright © 2020 SKOUMAL, s.r.o. All rights reserved.
//

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
        Bundle(for: OfflineView.self).loadNibNamed("OfflineView", owner: self, options: nil)
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
        
        titleLabel.text = NSLocalizedString("Something went wrong", comment: "")
        subtitleLabel.text = NSLocalizedString("Check your internet connection and try again.", comment: "")
        tryAgainButton.setTitle(NSLocalizedString("Try again", comment: ""), for: .normal)
        
        tryAgainButton.layer.borderWidth = 1.0
        tryAgainButton.layer.borderColor = UIColor.systemBlue.cgColor
        tryAgainButton.layer.cornerRadius = 8.0
        
    }

}
