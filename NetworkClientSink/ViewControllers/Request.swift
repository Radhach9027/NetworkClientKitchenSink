import Combine
import NetworkClient
import UIKit

class Request: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    @IBOutlet var image: UIImageView!
    @IBOutlet var text: UILabel!
    @IBOutlet var subText: UILabel!
    private lazy var service = RequestService(network: Network(config: .default()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        execute(type: .serial)
    }
}

private extension Request {
    enum RequestType {
        case data, codable, serial, concurrent
    }
    
    func execute(type: RequestType) {
        switch type {
            case .data:
                dataRequest()
            case .codable:
                codableRequest()
            case .serial:
                serialRequests()
            case .concurrent:
                concurrentRequests()
        }
    }
    
    func dataRequest() {
        service.request(endpoint: .fetch, receive: .main)
            .receive(on: DispatchQueue.main)
            .decode(type: NasaAstronomy.self, decoder: JSONDecoder())
            .sink { [weak self] result in
                switch result {
                case .finished:
                    debugPrint("Request finished")
                case let .failure(error):
                    if let error = error as? NetworkError {
                        self?.present(withTitle: error.title.value, message: error.errorMessage.value)
                    }
                }
            } receiveValue: { [weak self] model in
                self?.image.load(url: URL(string: model.url)!)
                self?.text.text = model.title
                self?.subText.text = model.explanation
            }
            .store(in: &cancellable)
    }

    func codableRequest() {
        service.request(endpoint: .fetch, codable: NasaAstronomy.self, receive: .main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    debugPrint("Request finished")
                case let .failure(error):
                    self?.present(withTitle: error.title.value, message: error.errorMessage.value)
                }
            } receiveValue: { [weak self] model in
                self?.image.load(url: URL(string: model.url)!)
                self?.text.text = model.title
                self?.subText.text = model.explanation
            }
            .store(in: &cancellable)
    }
    
    
    func serialRequests() {
        service.serialRequests(endpoints: [.fetch, .fetch, .fetch], receive: .main)
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .decode(type: NasaAstronomy.self, decoder: JSONDecoder())
            .sink { result in
                switch result {
                    case .finished:
                        debugPrint("serialRequests finished")
                    case let .failure(error):
                        debugPrint("serialRequests failed = \(error.localizedDescription)")
                }
            } receiveValue: { model in
                debugPrint("serialRequests model = \(model)")
            }
            .store(in: &cancellable)
    }
    
    func concurrentRequests() {
        
    }
}
