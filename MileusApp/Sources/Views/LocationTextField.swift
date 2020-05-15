//
//  LocationTextField.swift
//  MileusApp
//
//  Created by Libor Polehna on 22/04/2020.
//  Copyright © 2020 SKOUMAL, s.r.o. All rights reserved.
//

import UIKit

class LocationTextField: TextField {

    override func setup() {
        super.setup()
        keyboardType = .decimalPad
    }

}
