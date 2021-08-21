//
//  OneTimeSearch.swift
//  MileusWatchdogKit
//
//  Created by Michal Miko on 21.08.2021.
//  Copyright © 2021 SKOUMAL, s.r.o. All rights reserved.
//

import UIKit


public final class MileusOneTimeSearch {
    
    private static var alreadyInitialized = false
    
    internal private(set) weak var delegate: MileusOneTimeSearchFlowDelegate?
    
    private var mileusSearch: MileusWatchdogSearch!
    
    public init(delegate: MileusOneTimeSearchFlowDelegate) throws {
        if Self.alreadyInitialized {
            throw MileusWatchdogError.instanceAlreadyExists
        }
        self.delegate = delegate
        mileusSearch = try MileusWatchdogSearch(
            delegate: self,
            locations: [],
            ignoreLocationPermission: false
        )
        mileusSearch.mode = .oneTimeSearch
        Self.alreadyInitialized = true
    }
    
    deinit {
        Self.alreadyInitialized = false
        debugPrint("DEINIT: \(String(describing: self))")
    }
    
    public func show(from: UIViewController) -> UINavigationController {
        mileusSearch.show(from: from)
    }
    
    public func updateHome(location: MileusWatchdogLocation) {
        mileusSearch.update(location: location, type: .home)
    }
    
}


extension MileusOneTimeSearch: MileusWatchdogSearchFlowDelegate {
    
    public func mileus(_ mileus: MileusWatchdogSearch, showSearch data: MileusWatchdogSearchData) {

    }
    
    public func mileusShowTaxiRide(_ mileus: MileusWatchdogSearch) {
        
    }
    
    public func mileusShowTaxiRideAndFinish(_ mileus: MileusWatchdogSearch) {
        
    }
    
    public func mileusDidFinish(_ mileus: MileusWatchdogSearch) {
        delegate?.mileusDidFinish(self)
    }
    
}
