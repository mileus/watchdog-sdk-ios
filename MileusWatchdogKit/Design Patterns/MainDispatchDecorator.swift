
import Foundation

final class MainDispatchDecorator {

    internal weak var decoratee: MileusWatchdogSearchFlowDelegate?

    init(decoratee: MileusWatchdogSearchFlowDelegate) {
        self.decoratee = decoratee
    }

    internal func performOnMainThread(action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }

}


extension MainDispatchDecorator: MileusWatchdogSearchFlowDelegate {
    func mileus(_ mileus: MileusWatchdogSearch, showSearch data: MileusWatchdogSearchData) {
        performOnMainThread { [weak self] in
            self?.decoratee?.mileus(mileus, showSearch: data)
        }
    }
    
    func mileusShowTaxiRide(_ mileus: MileusWatchdogSearch) {
        performOnMainThread { [weak self] in
            self?.decoratee?.mileusShowTaxiRide(mileus)
        }
    }
    
    func mileusShowTaxiRideAndFinish(_ mileus: MileusWatchdogSearch) {
        performOnMainThread { [weak self] in
            self?.decoratee?.mileusShowTaxiRideAndFinish(mileus)
        }
    }
    
    func mileusDidFinish(_ mileus: MileusWatchdogSearch) {
        performOnMainThread { [weak self] in
            self?.decoratee?.mileusDidFinish(mileus)
        }
    }
    
    func mileusDidFinish(_ mileus: MileusWatchdogSearch, with error: MileusFlowError) {
        performOnMainThread { [weak self] in
            self?.decoratee?.mileusDidFinish(mileus, with: error)
        }
    }
}
