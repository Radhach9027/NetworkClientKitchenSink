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
    
    func request<T>(endpoint: RequestEndPoint, codable: T.Type, receive: DispatchQueue) -> AnyPublisher<T, NetworkError> where T: Decodable {
        return network.request(for: endpoint, codable: T.self, receive: receive)
    }
}
