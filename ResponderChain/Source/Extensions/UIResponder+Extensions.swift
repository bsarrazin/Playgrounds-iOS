import UIKit

extension UIResponder {
    @objc func dismiss() {
        next?.dismiss()
    }
    @objc func presentGreenView() {
        next?.presentGreenView()
    }
}

extension UIViewController {
    open override var next: UIResponder? {
        return navigationController ?? presentingViewController ?? super.next
    }
}
