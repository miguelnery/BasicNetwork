import Foundation
import XCTest
@testable import BasicNetwork

final class EndpointFetcherMock: EndpointFectcher {
    var fetchFromEndpointImpl: ((Endpoint) -> Result<Data, ServiceError>)?
    func fetch(from endpoint: Endpoint) async -> Result<Data, ServiceError> {
        guard let impl = fetchFromEndpointImpl else {
            XCTFail("Must define implementation before calling this method.")
            return .failure(.badURL)
        }
        return impl(endpoint)
    }
}
