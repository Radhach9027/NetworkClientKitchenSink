import Combine
import NetworkClient
import UIKit

class UploadMultipart: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet var image: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    private let service = UploadMultipartService(network: Network(config: .default))

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func uploadMultipart(sender: UIButton) {
        if let data = image.image?.pngData() {
            service.upload(endpoint: .image(
                name: "profilePicture",
                data: data,
                mimeType: "img/png"
            ), receive: .main)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    switch result {
                    case .finished:
                        debugPrint("uploadMultipart finished")
                    case let .failure(error):
                        self?.present(withTitle: error.title.value, message: error.errorMessage.value)
                    }
                } receiveValue: { [weak self] response in
                    switch response {
                    case let .progress(percentage):
                        debugPrint("uploadMultipart percentage = \(percentage)")
                        self?.progressView.progress = percentage
                    case let .response(data):
                        debugPrint("uploadMultipart success = \(data)")
                    }
                }
                .store(in: &cancellable)
        }
    }
}
