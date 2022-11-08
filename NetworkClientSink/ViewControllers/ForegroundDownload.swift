import Combine
import NetworkClient
import UIKit

class ForegroundDownload: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var image: UIImageView!
    private lazy var service = DownloadService(network: Network.defaultSession)

    override func viewDidLoad() {
        super.viewDidLoad()
        download()
    }
}

private extension ForegroundDownload {
    func download() {
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
                    self?.progressView.progress = percentage
                case let .response(url):
                    self?.image.load(url: url)
                }
            }
            .store(in: &cancellable)
    }
}
