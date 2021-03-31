@testable import APIota
import Foundation

struct TestAPIClient: APIotaClient {

    let session = URLSession.shared

    let decoder = JSONDecoder()

    var baseUrlComponents: URLComponents = {
        var components = URLComponents()
        components.host = "jsonplaceholder.typicode.com"
        components.scheme = "https"

        return components
    }()
}
