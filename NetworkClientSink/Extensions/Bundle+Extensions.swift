import Foundation

extension Bundle {
    static var identifier: String {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            return bundleIdentifier
        }

        return "Chandan.NetworkClientSink"
    }
}
