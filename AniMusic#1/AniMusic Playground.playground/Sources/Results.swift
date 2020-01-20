import Foundation

public struct Results: Encodable {
    var results: [String: Data]

    enum CodingKeys: String, CodingKey {
        case results
    }
}
