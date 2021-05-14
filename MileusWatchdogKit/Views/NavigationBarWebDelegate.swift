
import Foundation


protocol NavigationBarWebDelegate: AnyObject {
    func setTitle(title: String?)
    func setInfoButton(viewModel: InfoButtonViewModel?)
}
