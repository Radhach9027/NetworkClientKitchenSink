import Foundation
import NetworkClient

enum DownloadEndpoint {
    case image
}

extension DownloadEndpoint: NetworkDownloadRequestProtocol {
    var saveDownloadedUrlToLocation: URL? {
        do {
            return try FileManager.createFolder(folder: "BGDownloads")
        } catch {
            print(error.localizedDescription)
            return nil // this will save to default location.
        }
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
