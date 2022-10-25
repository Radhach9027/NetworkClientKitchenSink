import Combine
import NetworkClient
import UIKit

class BackgroundDownload: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var image: UIImageView!
    private var service = DownloadService(
        network: Network(
            config: .background(identifer: Bundle.identifier),
            urlSessionDidFinishEvents: { _ in
                DispatchQueue.main.async {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                       let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                        appDelegate.backgroundSessionCompletionHandler = nil
                        completionHandler()
                    }
                }
            }
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        service.download(endpoint: .image, receive: .main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    debugPrint("BackgroundDownload finished")
                    self?.progressView.progress = .zero
                case let .failure(error):
                    self?.present(withTitle: error.title.value, message: error.errorMessage.value)
                }
            } receiveValue: { [weak self] response in
                switch response {
                case let .progress(percentage):
                    debugPrint("BackgroundDownload percentage = \(percentage)")
                    self?.progressView.progress = percentage
                case let .response(url):
                    self?.image.load(url: url)
                }
            }
            .store(in: &cancellable)
    }
}
