import Combine
import NetworkClient
import UIKit

final class BackgroundDownload: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var image: UIImageView!
    private lazy var service = DownloadService(
        network: Network.backgroundSession(urlSessionDidFinishEvents: { _ in
            DispatchQueue.main.async {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                   let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                    appDelegate.backgroundSessionCompletionHandler = nil
                    completionHandler()
                }
            }
        })
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundDownload()
    }
}

private extension BackgroundDownload {
    func backgroundDownload() {
        service.download(endpoint: .image, receive: .main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    self?.progressView.progress = .zero
                case let .failure(error):
                    self?.present(withTitle: error.title.value, message: error.errorMessage.value)
                }
            } receiveValue: { [weak self] response in
                switch response {
                case let .progress(percentage):
                    self?.progressView.progress = percentage
                case let .response(url):
                    self?.image.load(url: url)
                }
            }
            .store(in: &cancellable)
    }
}
