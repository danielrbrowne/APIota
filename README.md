![APIota](./apiota_logo.png?raw=true)

# APIota

APIota is a lightweight Swift library for defining API clients for use in iOS and macOS apps. It is written using a protocol-oriented approach, and allows your `Codable` model objects to be decoded from JSON REST API endpoints really easily!

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Reporting Bugs and Requesting Features](#reporting-bugs-and-requesting-features)
- [Feature Roadmap](#feature-roadmap)
- [License](#license)

## Features

- [x] JSON request and response body encoding and decoding support when using model objects conforming to `Codable`.
- [x] [Combine](https://developer.apple.com/documentation/combine) support (when building against iOS 13.0+ or macOS 10.15+).
- [x] URL-encoded form data request support.

## Installation

### Using Swift Package Manager

Simply add the following to the `dependencies` array in your `Package.swift` file:

```
dependencies: [
    …
    .package(url: "https://github.com/danielrbrowne/APIota", from: "0.1.0"),
    …
  ]
```

## Usage

At its core, defining API clients using APIota is very straightforward. There are two protocols, `APIotaClient` and `APIotaCodableEndpoint` which form the foundations of the library.

The first step is to define an object specifying the base URL (i.e. the `host` in terms of an instance of `URLComponents`) for the REST API with which you are going to communicate with. An example is shown below:

```
struct JSONPlaceholderAPIClient: APIotaClient {

    let session = URLSession.shared

    let decoder = JSONDecoder()

    var baseUrlComponents: URLComponents = {
        var components = URLComponents()
        components.host = "jsonplaceholder.typicode.com"
        components.scheme = "https"

        return components
    }()
}

```

The next step is to define the endpoint that the requests should be sent to. An example of a simple GET request is shown below, however more complex requests can also be defined easily:

```
struct JSONPlaceholderGetTodosEndpoint: APIotaCodableEndpoint {
    typealias Response = [Todo]
    typealias Body = String

    let headers: HTTPHeaders? = nil

    let httpBody: Body? = nil

    let httpMethod: HTTPMethod = .GET

    let path = "/todos"

    let queryItems: [URLQueryItem]? = nil
}
```

Requests can then be sent to REST API via an instance of the Client as follows:

```
…
private static let apiClient = TestAPIClient()
private(set) lazy var cancellable: AnyCancellable? = nil
private var todosList: [Todo] = []
…

// Example 1: API response returned via a callback closure

let endpoint = JSONPlaceholderGetTodosEndpoint()
Self.apiClient.sendRequest(for: endpoint) { result in
    // Handle the returned `Result<T.Response, Error>`
    switch result {
    case .success(let todosList):
        self.todosList = todosList
    case .failure(let error):
        // Handle the error returned from the API Client
    }
}

// Example 2: API response returned via a Combine publisher

let endpoint = JSONPlaceholderGetTodosEndpoint()
cancellable = Self.apiClient.sendRequest(for: endpoint)
    .catch({ error in
        // Handle the error returned from the API Client
    })
    .assign(to: \.todosList, on: self)
}

```

A practical example of APIota in action can be found in the [Example Project](./Example/APIotaExample.xcproj).

## Reporting Bugs and Requesting Features

Please ensure you use the relevant issue template when reporting a bug or requesting a new feature. Also please check first to see if there is an open issue that already covers your bug report or new feature request.

## Feature Roadmap

In no particular order, and as a draft proposal:

- [ ] Customizable JSON encoding strategies for requests.
- [ ] Automatic `Content-Type` header inference for requests.
- [ ] Configurable response caching for requests.
- [ ] Multipart form data support.
- [ ] Configurable request retrying.
- [ ] Request authentication challenge handling.
- [ ] Comprehensive test coverage.
- [ ] Cocoapods and Homebrew installation support.

## License

APIota is completely open source and released under the MIT license. See [LICENSE.md](https://github.com/danielrbrowne/APIota/blob/master/LICENSE.md) for details if you want to use it in your own project(s).