import Foundation

public protocol APIotaEndpoint {
    associatedtype Response: Decodable
    associatedtype Body: Encodable
    
    var headers: HTTPHeaders? { get }
    
    var httpBody: Body? { get }
    
    var httpMethod: HTTPMethod { get }
    
    var path: String { get }
    
    var queryItems: [URLQueryItem]? { get }

    func request(baseUrlComponents: URLComponents) throws -> URLRequest
}

// MARK: - Default method implementations

extension APIotaEndpoint {
    
    func request(baseUrlComponents: URLComponents) throws -> URLRequest {
        
        var requestUrlComponents = baseUrlComponents
        requestUrlComponents.path = path
        requestUrlComponents.queryItems = queryItems
        
        guard let requestUrl = requestUrlComponents.url else {
            throw APIotaClientError.clientSide
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod.rawValue
        if let httpBody = httpBody, let bodyData = try? JSONEncoder().encode(httpBody) {
            request.httpBody = bodyData
        }
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers.allHTTPHeaderFields
        }
        
        return request
    }
}
