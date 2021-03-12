
import Foundation


@propertyWrapper
class LocationWrapper {
    
    private var value: String?
    
    init(value: String?) {
        wrappedValue = value
    }
    
    var wrappedValue: String? {
        set {
            if newValue?.isEmpty ?? true {
                value = nil
            } else {
                let sep = Locale.current.decimalSeparator ?? "."
                value = newValue?.replacingOccurrences(of: ".", with: sep)
            }
        }
        get {
            return value
        }
    }
    
    var projectedValue: Double {
        set {
            wrappedValue = String(newValue)
        }
        get {
            return Double((value?.replacingOccurrences(of: ",", with: ".") ?? "0.0"))!
        }
    }
    
}
