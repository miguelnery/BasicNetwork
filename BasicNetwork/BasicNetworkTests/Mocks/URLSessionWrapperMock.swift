import XCTest
@testable import BasicNetwork

final class URLSessionWrapperMock: URLSessionWrapper {
    var dataFromURLImpl: ((URL) throws -> (Data, URLResponse))?
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        guard let impl = dataFromURLImpl else {
            XCTFail("Must define implementation before calling this method.")
            throw URLError(.unknown)
        }
        return try impl(url)
    }
}
