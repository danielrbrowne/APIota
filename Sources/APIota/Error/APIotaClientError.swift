import Foundation

public enum APIotaClientError: LocalizedError {
    case clientSide
    case failedResponse(statusCode: HTTPStatusCode)
    case unexpectedResponse

    public var errorDescription: String? {
        switch self {
        case .clientSide:
            return NSLocalizedString("The URLRequest was not initialized with a valid URL.",
                                     comment: "'clientSide' API Client error text")
        case .failedResponse(statusCode: let statusCode):
            return NSLocalizedString("The response failed with HTTP status code: \(statusCode)",
                comment: "'failedResponse' API Client error text")
        case .unexpectedResponse:
            return NSLocalizedString("The response was of an unexpected format.",
                                     comment: "'unexpectedResponse' API Client error text")
        }
    }
}

// MARK: - Equatable conformance

extension APIotaClientError: Equatable {

    public static func == (lhs: APIotaClientError, rhs: APIotaClientError) -> Bool {
        switch (lhs, rhs) {
        case ( .clientSide, .clientSide):
            return true
        case (let .failedResponse(codeOne), let .failedResponse(codeTwo)):
            return codeOne == codeTwo
        case ( .unexpectedResponse, .unexpectedResponse):
            return true
        default:
            return false
        }
    }
}
