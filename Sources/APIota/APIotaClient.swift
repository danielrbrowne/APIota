import Foundation
import Combine

public protocol APIotaClient {
    var session: URLSession { get }
    
    var decoder: JSONDecoder { get }
    
    var baseUrlComponents: URLComponents { get }
    
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T,
                                               callback: @escaping (Result<T.Response, Error>) -> Void)

    @available(iOS 13.0, macOS 10.15, *)
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T) -> AnyPublisher<T.Response, Error>
}

// MARK: - Default method implementations

public extension APIotaClient {
    
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T,
                                               callback: @escaping (Result<T.Response, Error>) -> Void) {

        var request: URLRequest!
        do {
            request = try endpoint.request(baseUrlComponents: baseUrlComponents)
        } catch {
            callback(.failure(error))
        }
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
                    callback(.failure(APIotaClientError.unexpectedResponse))
                    return
            }
            
            guard statusCode.category == .successful else {
                callback(.failure(APIotaClientError.failedResponse(statusCode: statusCode)))
                return
            }
            
            do {
                callback(.success(try self.decoder.decode(T.Response.self, from: data!)))
            } catch {
                callback(.failure(error))
                return
            }
        }
        
        // Resume (a.k.a start) data task before exiting scope
        dataTask.resume()
    }

    @available(iOS 13.0, macOS 10.15, *)
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T) -> AnyPublisher<T.Response, Error> {

        var request: URLRequest!
        do {
            request = try endpoint.request(baseUrlComponents: self.baseUrlComponents)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return self.session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                    let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
                        throw APIotaClientError.unexpectedResponse
                }

                guard statusCode.category == .successful else {
                    throw APIotaClientError.failedResponse(statusCode: statusCode)
                }

                return result.data
        }
        .decode(type: T.Response.self, decoder: decoder)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
