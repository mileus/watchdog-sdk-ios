
import Foundation


extension Bundle {
    
    static func bundle(for aClass: AnyClass) -> Bundle {
        let bundle: Bundle
#if SWIFT_PACKAGE
        bundle = Bundle.module
#else
        bundle = Bundle(for: aClass)
#endif
        return bundle
    }
    
}
