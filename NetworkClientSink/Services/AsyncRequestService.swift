import Combine
import Foundation
import NetworkClient

@available(iOS 15.0, *)
final class AsyncRequestService: ObservableObject {
    private var network: AsyncNetworkProtocol
    
    init(network: AsyncNetworkProtocol) {
        self.network = network
    }
    
    func asyncRequest(endpoint: RequestEndPoint, receive: DispatchQueue) async throws -> AnyPublisher<Data, NetworkError> {
        try await network.request(request: endpoint, receive: receive)
    }
}

