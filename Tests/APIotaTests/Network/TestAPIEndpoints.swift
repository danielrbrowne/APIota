@testable import APIota
import Foundation

struct TestTodosGetEndpoint: APIotaCodableEndpoint {
    typealias SuccessResponse = [Todo]
    typealias ErrorResponse = Data
    typealias Body = String

    let encoder = JSONEncoder()

    let headers: HTTPHeaders? = nil

    let httpBody: Body? = nil

    let httpMethod: HTTPMethod = .GET

    let path = "/todos"

    let queryItems: [URLQueryItem]? = nil
}

struct TestTodosCreateEndpoint: APIotaCodableEndpoint {
    typealias SuccessResponse = Todo
    typealias ErrorResponse = Data
    typealias Body = Todo

    let encoder = JSONEncoder()

    let headers: HTTPHeaders? = [.contentType: HTTPMediaType.json.toString()]

    let httpBody: Body?

    let httpMethod: HTTPMethod = .POST

    let path = "/todos"

    let queryItems: [URLQueryItem]? = nil
}

struct TestTodosUpdateEndpoint: APIotaCodableEndpoint {
    typealias SuccessResponse = Todo
    typealias ErrorResponse = Data
    typealias Body = Todo

    let encoder = JSONEncoder()

    let headers: HTTPHeaders? = [.contentType: HTTPMediaType.json.toString()]

    let httpBody: Body?

    let httpMethod: HTTPMethod

    let path: String

    let queryItems: [URLQueryItem]? = nil

    init(httpBody: Body? = nil, httpMethod: HTTPMethod, todoId: Int) {
        self.httpBody = httpBody
        self.httpMethod = httpMethod
        self.path = "/todos/\(todoId)"
    }
}
