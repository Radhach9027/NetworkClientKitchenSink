import Combine
import Foundation
import NetworkClient

final class UploadMultipartService: ObservableObject {
    private var network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

    func upload(endpoint: UploadMultipartEndPoint, receive: DispatchQueue) -> PassthroughSubject<UploadNetworkResponse, NetworkError> {
         network.uploadMultipart(with: endpoint, receive: .main)
    }
}
