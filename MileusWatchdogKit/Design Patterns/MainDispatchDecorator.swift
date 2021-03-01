
import Foundation

final class MainDispatchDecorator<DecorateeType> {

    internal let decoratee: DecorateeType

    init(decoratee: DecorateeType) {
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
