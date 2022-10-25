import Combine
import NetworkClient
import UIKit

class ForegroundDownload: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var image: UIImageView!
    private let service = DownloadService(network: Network(config: .default()))

    override func viewDidLoad() {
        super.viewDidLoad()
        service.download(endpoint: .image, receive: .main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    debugPrint("ForegroundDownload finished")
                case let .failure(error):
                    self?.present(withTitle: error.title.value, message: error.errorMessage.value)
                }
            } receiveValue: { [weak self] response in
                switch response {
                case let .progress(percentage):
                    debugPrint("ForegroundDownload percentage = \(percentage)")
                    self?.progressView.progress = percentage
                case let .response(url):
                    self?.image.load(url: url)
                }
            }
            .store(in: &cancellable)
    }
}
