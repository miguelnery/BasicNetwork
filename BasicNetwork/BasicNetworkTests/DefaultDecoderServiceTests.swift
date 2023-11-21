import XCTest
@testable import BasicNetwork

final class DefaultDecoderServiceTests: XCTestCase {
    let fetcherMock = EndpointFetcherMock()
    lazy var sut = DefaultDecoderService(fetcher: fetcherMock, jsonDecoder: .init())
    
    func test_fetch_WhenFetchFails_ShouldReturnSameFailure() async {
        for error in ServiceError.allCases {
            let expectedError = error
            fetcherMock.fetchFromEndpointImpl = { _ in
                return .failure(expectedError)
            }
            let result: Result<String, ServiceError> = await sut.fetch(from: EndpointMock.validURL)
            
            XCTAssertEqual(result, .failure(expectedError))
        }
    }
    
    func test_fetch_WhenFailToDecode_ShouldFailWithDecode() async throws {
        let encodedValue = try XCTUnwrap("not a json".data(using: .utf16))
        fetcherMock.fetchFromEndpointImpl = { _ in
            return .success(encodedValue)
        }
        let result: Result<MockModel, ServiceError> = await sut.fetch(from: EndpointMock.validURL)
        XCTAssertEqual(result, .failure(.decode))
    }
    
    func test_fetch_WhenSucceeds_ShouldSucceedWithDecodedData() async throws {
        let expectedValue = MockModel(value: "someValue")
        let encodedValue = try XCTUnwrap(JSONEncoder().encode(expectedValue))
        fetcherMock.fetchFromEndpointImpl = { _ in
            return .success(encodedValue)
        }
        let result: Result<MockModel, ServiceError> = await sut.fetch(from: EndpointMock.validURL)
        XCTAssertEqual(result, .success(expectedValue))
    }
}
