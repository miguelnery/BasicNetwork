import Foundation

struct MockModel: Codable, Equatable {
    let value: String
}

extension MockModel {
    static let jsonString = """
{
    "someKey": "Durian"
}
"""
    static var encodedJson: Data? { jsonString.data(using: .utf8) }
}
