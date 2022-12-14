import Combine
import NetworkClient
import UIKit

@available(iOS 15.0, *)
final class AsyncRequest: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet private var image: UIImageView!
    @IBOutlet private var text: UILabel!
    @IBOutlet private var subText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
