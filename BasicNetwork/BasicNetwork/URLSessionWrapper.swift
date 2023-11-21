import Combine
import Foundation

public protocol URLSessionWrapper {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

public final class DefaultURLSessionWrapper {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension DefaultURLSessionWrapper: URLSessionWrapper {
    public func data(from url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        try await urlSession.data(from: url)
    }
}
