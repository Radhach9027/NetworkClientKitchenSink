import Foundation
import NetworkClient

enum DownloadEndpoint {
    case image
}

extension DownloadEndpoint: NetworkDownloadRequestProtocol {
    var saveDownloadedUrlToLocation: URL? {
        nil // save to default
    }

    var urlPath: String {
        switch self {
        case .image:
            return "/jpeg/PIA08506.jpg"
        }
    }

    var httpMethod: NetworkRequestMethod {
        switch self {
        case .image:
            return .get
        }
    }

    var baseURL: String {
        switch self {
        case .image:
            return "https://photojournal.jpl.nasa.gov"
        }
    }

    var urlComponents: URLComponents? {
        return URLComponents(string: baseURL + urlPath)
    }
}
