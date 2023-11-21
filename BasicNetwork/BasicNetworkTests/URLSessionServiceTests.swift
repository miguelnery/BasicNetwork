import XCTest
@testable import BasicNetwork

final class URLSessionServiceTests: XCTestCase {
    let urlSessionWrapperMock = URLSessionWrapperMock()
    lazy var sut = URLSessionService(urlSession: urlSessionWrapperMock)
    
    func test_publisherForEndpoint_WhenURLIsInvalid_ShouldFailWithBadURL() async {
        let result = await sut.fetch(from: EndpointMock.badURL)
        XCTAssertEqual(result, .failure(.badURL))
    }

    func test_publisherForEndpoint_WhenItFails_ShouldFailtWithRequest() async {
        let expectedError = URLError(.badServerResponse)
        urlSessionWrapperMock.dataFromURLImpl = { _ in throw expectedError }
        let result = await sut.fetch(from: EndpointMock.validURL)
        XCTAssertEqual(result, .failure(.request))
    }

    func test_publisherForEndpoint_WhenItSucceeds_ShouldPublishData() async throws {
        let expectedData = try XCTUnwrap("someModel".data(using: .utf16))
        urlSessionWrapperMock.dataFromURLImpl = { _ in (expectedData, .init()) }
        let result = await sut.fetch(from: EndpointMock.validURL)
        XCTAssertEqual(result, .success(expectedData))
    }
}
