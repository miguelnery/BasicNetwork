import Foundation

public final class URLSessionService<SessionWrapper: URLSessionWrapper> {
    private let urlSession: SessionWrapper
    
    init(urlSession: SessionWrapper = DefaultURLSessionWrapper()) {
        self.urlSession = urlSession
    }
}

extension URLSessionService: EndpointFectcher {
    public func fetch(from endpoint: Endpoint) async -> Result<Data, ServiceError> {
        guard let url = endpoint.urlRequest?.url else {
            return .failure(.badURL)
        }
        
        if let (data, _) = try? await urlSession.data(from: url, delegate: nil) {
            return .success(data)
        } else {
            return .failure(.request)
        }
    }
}
