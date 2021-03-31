import Foundation
#if canImport(Combine)
import Combine
#endif

/// Defines an API Client.
///
/// The definition includes a `session`, a `decoder` and a `baseURLComponents`.
/// that should be used when sending `URLRequests` to the REST API server specified.
public protocol APIotaClient {

    /// A `URLSession` to use for sending `URLRequest`s from the Client to the REST API.
    var session: URLSession { get }

    /// A `JSONDecoder` to use for decoding the responses received by the Client from the REST API.
    var decoder: JSONDecoder { get }

    /// Used to define the base URL (i.e. `host`), and any other root-level components of the REST API.
    var baseUrlComponents: URLComponents { get }

    /// Send a `URLRequest` to the specified REST API, returning a response via a callback closure.
    /// - Parameters:
    ///   - endpoint: An `APIotaCodableEndpoint` defining the format of the `URLRequest` to be sent.
    ///   - callback: A closure executed when a response (or an error) is returned as a result of
    ///   sending the `URLRequest` to the REST API.
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T,
                                               callback: @escaping (Result<T.Response, Error>) -> Void)

    #if canImport(Combine)

    /// Send a `URLRequest` to the specified REST API, returning a response via a Combine `AnyPublisher`.
    /// - Parameter endpoint: An `APIotaCodableEndpoint` defining the format of the `URLRequest` to be sent.
    /// - Returns: An `AnyPublisher` which can be integrated with SwiftUI or Combine code paths.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T) -> AnyPublisher<T.Response, Error>

    #endif
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

        let dataTask = session.dataTask(with: request) { data, response, error in
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

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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

    #endif
}
