import Foundation
import NetworkClient

extension Network {
    
    class var certificate: SecCertificate? {
        switch SecCertificate.loadFromBundle() {
            case .success(let cert):
                return cert
            case .failure(let error):
                print(error)
                return nil
        }
    }
    
    class var defaultSession: Network {
        guard let certificate = certificate else {
            return Network(config: .default())
        }
        
        let network = Network(
            config: .default(),
            pinning: SSLPinning.certificatePinning(certificate: certificate, hash: SecCertificate.hashKey)
        )
        return network
        
    }
    
    class func backgroundSession(urlSessionDidFinishEvents: @escaping (URLSession)-> Void) -> Network {
        guard let certificate = certificate else {
            return Network(
                config: .background(identifer: Bundle.identifier),
                urlSessionDidFinishEvents: urlSessionDidFinishEvents
            )
        }
        
        let network = Network(
            config: .background(identifer: Bundle.identifier),
            pinning: SSLPinning.certificatePinning(certificate: certificate, hash: SecCertificate.hashKey),
            urlSessionDidFinishEvents: urlSessionDidFinishEvents
        )
        return network
    }
}
