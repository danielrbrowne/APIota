import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
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
                                               callback: @escaping (Result<T.SuccessResponse, Error>) -> Void)

    #if canImport(Combine)

    /// Send a `URLRequest` to the specified REST API, returning a response via a Combine `AnyPublisher`.
    /// - Parameter endpoint: An `APIotaCodableEndpoint` defining the format of the `URLRequest` to be sent.
    /// - Returns: An `AnyPublisher` which can be integrated with SwiftUI or Combine code paths.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T) -> AnyPublisher<T.SuccessResponse, Error>

    #endif
}

// MARK: - Default method implementations

public extension APIotaClient {

    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T,
                                               callback: @escaping (Result<T.SuccessResponse, Error>) -> Void) {

        var request: URLRequest!
        do {
            request = try endpoint.request(baseUrlComponents: baseUrlComponents)
        } catch {
            callback(.failure(error))
        }

        let dataTask = session.dataTask(with: request) { data, response, error in

            guard error == nil else {
                defer {
                    session.invalidateAndCancel()
                }
                callback(.failure(error!))

                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
                callback(.failure(APIotaClientError<T.ErrorResponse>.unexpectedResponse))

                return
            }

            guard statusCode.category == .successful else {

                // Decode an error response body based on `ErrorResponse` type if possible
                // Otherwise, if a body is present but cannot be decoded it is returned as-is.
                // If there was no response body, an empty `Data` object is returned.
                if let data = data {
                    if let decodedBody = try? self.decoder.decode(T.ErrorResponse.self,
                                                                  from: data) {
                        callback(.failure(APIotaClientError.failedResponse(statusCode: statusCode,
                                                                           errorResponseBody: decodedBody)))
                    } else {
                        callback(.failure(APIotaClientError.failedResponse(statusCode: statusCode,
                                                                           errorResponseBody: data)))
                    }
                } else {
                    callback(.failure(APIotaClientError.failedResponse(statusCode: statusCode,
                                                                       errorResponseBody: Data())))
                }

                return
            }

            do {
                callback(.success(try self.decoder.decode(T.SuccessResponse.self, from: data!)))
            } catch let error as DecodingError {
                callback(.failure(APIotaClientError<T.ErrorResponse>.decodingError(error)))
                return
            } catch {
                callback(.failure(APIotaClientError<T.ErrorResponse>.internalError(error)))
            }
        }

        // Resume (a.k.a start) data task before exiting scope
        dataTask.resume()
    }

    #if canImport(Combine)

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func sendRequest<T: APIotaCodableEndpoint>(for endpoint: T) -> AnyPublisher<T.SuccessResponse, Error> {

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
                    throw APIotaClientError<T.ErrorResponse>.unexpectedResponse
                }

                guard statusCode.category == .successful else {
                    // Decode an error response body based on `ErrorResponse` type if possible
                    // Otherwise, if a body cannot be decoded it is returned as-is.
                    if let decodedBody = try? self.decoder.decode(T.ErrorResponse.self,
                                                                  from: result.data) {
                        throw APIotaClientError.failedResponse(statusCode: statusCode,
                                                               errorResponseBody: decodedBody)
                    } else {
                        throw APIotaClientError.failedResponse(statusCode: statusCode,
                                                               errorResponseBody: result.data)
                    }
                }

                return result.data
            }
            .decode(type: T.SuccessResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    #endif
}
