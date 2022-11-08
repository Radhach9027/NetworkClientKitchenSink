import Combine
import Foundation
import NetworkClient

final class SocketService: ObservableObject {
    private var network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func startSession(endPoint: SocketEndpoint, completion: @escaping (NetworkError?) -> Void) {
        network.start(for: endPoint, completion: completion)
    }
    
    func send(message: NetworkSocketMessage, completion: @escaping (NetworkError?) -> Void) {
        network.send(message: message, completion: completion)
    }
    
    func receive() -> PassthroughSubject<NetworkSocketMessage, NetworkError> {
        network.receive()
    }
    
    func cancelSession(cancelCode: URLSessionWebSocketTask.CloseCode, reason: String? = nil) {
        network.cancel(with: cancelCode, reason: reason)
    }
}

