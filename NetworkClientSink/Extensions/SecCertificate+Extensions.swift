import Foundation

enum SecCertificateResult<S, F> {
    case success(S)
    case failure(F)
}

extension SecCertificate {
    enum Certificate {
        static let name = "stackoverflow"
    }

    static var hashKey: String {
        "put your public key"
    }

    static func loadFromBundle(
        certName: String = Certificate.name,
        bundle: Bundle = Bundle.main
    ) -> SecCertificateResult<SecCertificate, String> {
        guard let filePath = bundle.path(
            forResource: certName,
            ofType: "cer"
        ) else {
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
