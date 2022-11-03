import Foundation
import NetworkClient

extension Network {
    class var defaultSession: Network {
        switch SecCertificate.loadFromBundle() {
        case let .success(certificate):
            return Network(
                config: .default(),
                pinning: SSLPinning.certificatePinning(
                    certificate: certificate,
                    hash: SecCertificate.hashKey
                )
            )
        case .failure:
            return Network(config: .default())
        }
    }

    class func backgroundSession(urlSessionDidFinishEvents: @escaping (URLSession) -> Void) -> Network {
        switch SecCertificate.loadFromBundle() {
        case let .success(certificate):
            return Network(
                config: .background(identifer: Bundle.identifier),
                pinning: SSLPinning.certificatePinning(
                    certificate: certificate,
                    hash: SecCertificate.hashKey
                ),
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
