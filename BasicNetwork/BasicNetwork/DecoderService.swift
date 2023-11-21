import Foundation

public protocol DecoderService {
    func fetch<T: Decodable>(from endpoint: Endpoint) async -> Result<T, ServiceError>
}

public final class DefaultDecoderService<Fetcher: EndpointFectcher> {
    private let fetcher: Fetcher
    private let jsonDecoder: JSONDecoder
    
    public init(fetcher: Fetcher, jsonDecoder: JSONDecoder) {
        self.fetcher = fetcher
        self.jsonDecoder = jsonDecoder
    }
}

// MARK: - DecoderService
extension DefaultDecoderService: DecoderService {
    public func fetch<T: Decodable>(from endpoint: Endpoint) async -> Result<T, ServiceError> {
        let result = await fetcher.fetch(from: endpoint)
        if case .failure(let error) = result {
            return .failure(error)
        }
        
        return tryDecode(result)
    }
}


// MARK: - Helpers
extension DefaultDecoderService {
    private func tryDecode<T: Decodable>(_ result: Result<Data, ServiceError>) -> Result<T, ServiceError> {
        guard
            let data = try? result.get(),
            let decoded = try? jsonDecoder.decode(T.self, from: data)
        else {
            return .failure(.decode)
        }
        return .success(decoded)
    }
}
