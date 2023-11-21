import Foundation

public protocol Endpoint {
    var urlRequest: URLRequest? { get }
}

public protocol EndpointFectcher {
    func fetch(from endpoint: Endpoint) async -> Result<Data, ServiceError>
}
