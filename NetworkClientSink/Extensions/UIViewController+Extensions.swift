import UIKit

extension UIViewController {
    func present(withTitle title: String = "Error",
                 message: String? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("You've pressed OK Button")
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
