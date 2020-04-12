//
//  Config.swift
//  MileusApp
//
//  Created by Libor Polehna on 12/04/2020.
//  Copyright © 2020 SKOUMAL, s.r.o. All rights reserved.
//

import Foundation


class Config {
    
    private enum UserDefaultsKeys: String {
        case accessToken = "AccessToken"
    }
    
    static let shared = Config()
    
    var accessToken: String? {
        set {
            userDefaults.setValue(newValue, forKey: UserDefaultsKeys.accessToken.rawValue)
        }
        get {
            userDefaults.string(forKey: UserDefaultsKeys.accessToken.rawValue)
        }
    }
    
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = .standard
    }
    
}
