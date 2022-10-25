import Foundation
import NetworkClient

enum UploadMultipartEndPoint {
    case image(name: String, data: Data, mimeType: String)
}

extension UploadMultipartEndPoint: NetworkMultipartUploadRequestProtocol {
    var baseURL: String {
        "your base endpoint"
    }

    var urlPath: String {
        "/uploadPicture"
    }

    var httpMethod: NetworkRequestMethod {
        .post
    }

    var boundary: String {
        UUID().uuidString
    }

    var urlComponents: URLComponents? {
        return URLComponents(string: baseURL + urlPath)
    }

    var httpHeaderFields: NetworkHTTPHeaderField? {
        .headerFields(fields: [.contentType: .multipartFormData(boundary: boundary)])
    }

    var multipartFormDataType: MultipartFormDataType {
        switch self {
        case let .image(name, data, mimeType):
            return .data(name: name, data: data, mimeType: mimeType)
        }
    }
}
