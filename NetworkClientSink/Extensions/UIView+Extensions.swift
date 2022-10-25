import UIKit

extension UIView {
    func pin(someView: UIView) {
        NSLayoutConstraint.activate([
            someView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            someView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            someView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            someView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
