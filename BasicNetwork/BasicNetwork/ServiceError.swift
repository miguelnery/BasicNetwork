public enum ServiceError: Error, Equatable, CaseIterable {
    case badURL
    case request
    case decode
}
