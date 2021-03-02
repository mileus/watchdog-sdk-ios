
import Foundation


protocol NavigationBarWebDelegate: class {
    func setTitle(title: String?)
    func setInfoButton(viewModel: InfoButtonViewModel?)
}
