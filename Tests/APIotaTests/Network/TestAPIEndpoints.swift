import Foundation
@testable import APIota

struct TestTodosGetEndpoint: APIotaEndpoint {
    typealias Response = [Todo]
    typealias Body = String

    let headers: HTTPHeaders? = nil

    let httpBody: Body? = nil

    let httpMethod: HTTPMethod = .GET

    let path = "/todos"

    let queryItems: [URLQueryItem]? = nil
}

struct TestTodosCreateEndpoint: APIotaEndpoint {
    typealias Response = Todo
    typealias Body = Todo

    let headers: HTTPHeaders? = [.contentType: HTTPMediaType.json.toString()]

    let httpBody: Body?

    let httpMethod: HTTPMethod = .POST

    let path = "/todos"

    let queryItems: [URLQueryItem]? = nil
}

struct TestTodosUpdateEndpoint: APIotaEndpoint {
    typealias Response = Todo
    typealias Body = Todo

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
