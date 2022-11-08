import Foundation
import NetworkClient

enum SocketEndpoint {
    case start
}

extension SocketEndpoint: NetworkRequestProtocol {
    var baseURL: String {
        "wss://echo.websocket.org"
    }
    
    var urlPath: String {
        ""
    }
    
    var urlComponents: URLComponents? {
        URLComponents(string: baseURL + urlPath)
    }
    
    var httpMethod: NetworkRequestMethod {
        .get
    }
}

