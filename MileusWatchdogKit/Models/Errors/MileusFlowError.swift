//
//  MileusFlowError.swift
//  MileusWatchdogKit
//
//  Created by Michal Miko on 30.08.2021.
//  Copyright © 2021 SKOUMAL, s.r.o. All rights reserved.
//

import Foundation

public enum MileusFlowError: Error {
    case invalidState(message: String)
}
