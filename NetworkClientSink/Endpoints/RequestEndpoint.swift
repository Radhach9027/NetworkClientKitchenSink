import Foundation
import NetworkClient

enum RequestEndPoint {
    case fetch
}

extension RequestEndPoint: NetworkRequestProtocol {
    var apiKey: String? {
        "l7eIYhKJYYmpXqbq8tSPHZC5qG1DFvcBCrsyOvhJ"
    }

    var baseURL: String {
        "https://api.nasa.gov"
    }

    var urlPath: String {
        "/planetary/apod"
    }

    var urlComponents: URLComponents? {
        var components = URLComponents(string: baseURL + urlPath)
        components?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        return components
    }

    var httpMethod: NetworkRequestMethod {
        .get
    }
}
