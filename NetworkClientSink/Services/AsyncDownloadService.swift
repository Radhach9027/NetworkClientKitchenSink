import Combine
import Foundation
import NetworkClient

@available(iOS 15.0, *)
final class AsyncDownloadService: ObservableObject {
    private var network: AsyncNetworkProtocol
    
    init(network: AsyncNetworkProtocol) {
        self.network = network
    }
    
    func startDownloads(urls: [URL]) async throws {
        
    }
}
