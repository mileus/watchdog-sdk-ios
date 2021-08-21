//
//  MileusOneTimeSearchFlowDelegate.swift
//  MileusWatchdogKit
//
//  Created by Michal Miko on 21.08.2021.
//  Copyright © 2021 SKOUMAL, s.r.o. All rights reserved.
//

import Foundation


public protocol MileusOneTimeSearchFlowDelegate: AnyObject {
    func mileusDidFinish(_ mileus: MileusOneTimeSearch)
}
