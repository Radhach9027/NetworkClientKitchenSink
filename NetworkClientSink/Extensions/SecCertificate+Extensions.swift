import Foundation

enum SecCertificateError<S, F> {
    case success(S)
    case failure(F)
}

extension SecCertificate {
    
    enum Certificate {
        static let cert = ""
    }
    
    static var hashKey: String {
        ""
    }
    
    static func loadFromBundle(certName: String = Certificate.cert,
                               bundle: Bundle = Bundle.main) -> SecCertificateError<SecCertificate, String> {
        
        guard let filePath = bundle.path(forResource: certName, ofType: "cer") else {
            return .failure("Couldn't load resource from \(bundle)")
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else {
                return .failure("Couldn't convert data as SecCertificateCreateWithData for file \(filePath)")
            }
            return .success(certificate)
            
        } catch {
            return .failure(error.localizedDescription)
        }
    }
}
