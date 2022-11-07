import Foundation
import NetworkClient

enum SocketEndpoint {
    case start
}

extension SocketEndpoint: NetworkRequestProtocol {
    var baseURL: String {
        "wss://demo.piesocket.com"
    }
    
    var urlPath: String {
        "/v3/1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self"
    }
    
    var urlComponents: URLComponents? {
        URLComponents(string: baseURL + urlPath)
    }
    
    var httpMethod: NetworkRequestMethod {
        .post
    }
}

