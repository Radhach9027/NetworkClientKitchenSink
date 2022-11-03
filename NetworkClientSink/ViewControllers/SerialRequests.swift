import Combine
import NetworkClient
import UIKit

class SerialRequests: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet var stack: UIStackView!
    private lazy var service = RequestService(network: Network.defaultSession)
    private lazy var makeImageView: (URL) -> UIImageView = { url in
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.load(url: url)
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        execute(type: .serial)
    }
}

private extension SerialRequests {
    enum RequestType {
        case serial, concurrent
    }

    func execute(type: RequestType) {
        switch type {
        case .serial:
            serialRequests()
        case .concurrent:
            concurrentRequests()
        }
    }

    func serialRequests() {
        service.serialRequests(endpoints: [.fetch, .fetch, .fetch], receive: .main)
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .decode(type: NasaAstronomy.self, decoder: JSONDecoder())
            .sink { [weak self] result in
                switch result {
                case .finished:
                    debugPrint("serialRequests finished")
                case let .failure(error):
                    if let error = error as? NetworkError {
                        self?.present(withTitle: error.title.value, message: error.errorMessage.value)
                    }
                }
            } receiveValue: { [weak self] model in
                if let url = URL(string: model.url),
                   let imageview = self?.makeImageView(url) {
                    self?.stack.addArrangedSubview(imageview)
                }
            }
            .store(in: &cancellable)
    }

    func concurrentRequests() {
    }
}
