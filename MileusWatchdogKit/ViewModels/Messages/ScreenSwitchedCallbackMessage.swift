//
//  ScreenSwitchedCallbackMessage.swift
//  MileusWatchdogKit
//
//  Created by Michal Miko on 18.05.2021.
//  Copyright © 2021 SKOUMAL, s.r.o. All rights reserved.
//


import Foundation


struct ScreenSwitchedCallback: WebViewMessage {
    
    let identifier = "screenSwitchedCallback"
    
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func canHandle(name: String) -> Bool {
        name == identifier
    }
    
    func execute(data: Any) -> Bool {
        action()
        return true
    }
    
}
