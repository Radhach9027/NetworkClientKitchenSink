import Combine
import Foundation
import NetworkClient

final class RequestService: ObservableObject {
    private var network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

    func request(endpoint: RequestEndPoint, receive: DispatchQueue) -> AnyPublisher<Data, NetworkError> {
        return network.request(for: endpoint, receive: receive)
    }
}
