import Foundation

public protocol APIotaURLEncodedEndpoint: APIotaEndpoint {

    var requestBodyQueryItems: [URLQueryItem] { get }
}

extension APIotaURLEncodedEndpoint {

    var httpBody: Body? {
        nil
    }

    var httpMethod: HTTPMethod {
        .POST
    }

    func request(baseUrlComponents: URLComponents) throws -> URLRequest {

        var requestUrlComponents = baseUrlComponents
        requestUrlComponents.path = path
        requestUrlComponents.queryItems = queryItems

        guard let requestUrl = requestUrlComponents.url else {
            throw APIotaClientError.clientSide
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod.rawValue

        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = requestBodyQueryItems
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

        if let headers = headers {
            request.allHTTPHeaderFields = headers.allHTTPHeaderFields
        }

        return request
    }
}
