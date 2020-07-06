import Foundation

public protocol APIotaURLEncodedFormEndpoint: APIotaCodableEndpoint where Body == Data {

    var requestBodyQueryItems: [URLQueryItem] { get }
}

extension APIotaURLEncodedFormEndpoint {

    var httpBody: Body? {
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = requestBodyQueryItems

        return requestBodyComponents.query?.data(using: .utf8)
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
        request.httpBody = httpBody

        if let headers = headers {
            request.allHTTPHeaderFields = headers.allHTTPHeaderFields
        }

        return request
    }
}
