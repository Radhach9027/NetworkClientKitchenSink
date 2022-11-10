import Foundation
import NetworkClient

extension Network {
    class var defaultSession: Network {
        switch SecCertificate.loadFromBundle() {
        case let .success(certificate):
            return Network(
                config: .default(),
                pinning: .certificatePinning(certificate: certificate)
            )
        case .failure:
            return Network(config: .default())
        }
    }

    class func backgroundSession(queue: OperationQueue, urlSessionDidFinishEvents: @escaping (URLSession) -> Void) -> Network {
        switch SecCertificate.loadFromBundle() {
        case let .success(certificate):
            return Network(
                config: .background(identifer: Bundle.identifier, queue: queue),
                pinning: .certificatePinning(certificate: certificate),
                urlSessionDidFinishEvents: urlSessionDidFinishEvents
            )
        case .failure:
            return Network(
                config: .background(identifer: Bundle.identifier),
                urlSessionDidFinishEvents: urlSessionDidFinishEvents
            )
        }
    }
}
