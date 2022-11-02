import Combine
import NetworkClient
import UIKit

class SerialRequests: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    private lazy var service = RequestService(network: Network(config: .default()))

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
                self?.image1.load(url: URL(string: model.url)!)
            }
            .store(in: &cancellable)
    }

    func concurrentRequests() {
    }
}
