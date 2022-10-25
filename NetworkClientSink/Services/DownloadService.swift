import Combine
import Foundation
import NetworkClient

final class DownloadService: ObservableObject {
    private var network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

    func download(endpoint: DownloadEndpoint, receive: DispatchQueue) -> PassthroughSubject<DownloadNetworkResponse, NetworkError> {
        return network.download(for: endpoint, receive: receive)
    }
}
