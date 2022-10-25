import Foundation

struct NasaAstronomy: Codable, Equatable {
    let date, explanation, mediaType, serviceVersion: String
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date, explanation
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
