![APIota](https://raw.githubusercontent.com/danielrbrowne/APIota/master/apiota_logo.png)

# APIota

[![CI Status](https://github.com/danielrbrowne/APIota/workflows/APIota%20CI/badge.svg)](https://github.com/danielrbrowne/APIota/actions)
[![Latest Release](https://img.shields.io/github/v/release/danielrbrowne/APIota)](https://github.com/danielrbrowne/APIota/releases)
[![API Docs](https://img.shields.io/badge/Docs-here!-lightgrey)](https://danielrbrowne.github.io/APIota/)
[![Supported Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdanielrbrowne%2FAPIota%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/danielrbrowne/APIota)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdanielrbrowne%2FAPIota%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/danielrbrowne/APIota)
[![LICENSE](https://img.shields.io/github/license/danielrbrowne/APIota)](https://github.com/danielrbrowne/APIota/blob/master/LICENSE.md)

APIota is a lightweight Swift library for defining API clients for use in iOS, macOS, tvOS, watchOS or Linux. It is written using a protocol-oriented approach, and allows your `Codable` model objects to be decoded from JSON REST API endpoints really easily!

- [Supported platforms](#supported-platforms)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Reporting bugs and requesting features](#reporting-bugs-and-requesting-features)
- [Feature roadmap](#feature-roadmap)
- [License](#license)

## Supported platforms

- iOS
- macOS
- tvOS
- watchOS * (see note below)
- Linux

**NOTE:**
- watchOS support is available as a user of the APIota library. However, building directly from source fails currently due to `XCTest` not being available on watchOS.

### Supported Swift language versions and build tools

- Swift 5.2 or higher
- Xcode 11.4 or higher

## Features

- [x] JSON request and response body encoding and decoding support when using `Codable` model objects.
  - Encoding and decoding strategies can be customized by supplying configured `JSONEncoder` or `JSONDecoder` instances.
- [x] [Combine](https://developer.apple.com/documentation/combine) support (when building against iOS 13.0+, macOS 10.15+, tvOS 13.0+ or watchOS 6.0+).
- [x] URL-encoded form data request support.

## Installation

### Using Swift Package Manager

Simply add the following to the `dependencies` array in your `Package.swift` file:

```swift
dependencies: [
    …
    .package(url: "https://github.com/danielrbrowne/APIota", from: "0.2.0"),
    …
  ]
```

## Usage

At its core, defining API clients using APIota is very straightforward. There are two protocols, `APIotaClient` and `APIotaCodableEndpoint` which form the foundations of the library.

The first step is to define an object specifying the base URL (i.e. the `host` in terms of an instance of `URLComponents`) for the REST API with which you are going to communicate with. An example is shown below:

```swift
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

```swift
struct JSONPlaceholderGetTodosEndpoint: APIotaCodableEndpoint {
    typealias SuccessResponse = [Todo]
    typealias ErrorResponse = MyDecodableError
    typealias Body = MyEncodableBody

    let headers: HTTPHeaders? = nil

    let httpBody: Body? = nil

    let httpMethod: HTTPMethod = .GET

    let path = "/todos"

    let queryItems: [URLQueryItem]? = nil
}
```

Requests can then be sent to REST API via an instance of the Client as follows:

```swift
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

## Documentation and References

Full documentation of APIota can be found in the [API docs](https://danielrbrowne.github.io/APIota/).

A practical example of APIota in action can be found in the [Example Project](./Example/APIotaExample/).

## Reporting bugs and requesting features

Please ensure you use the relevant issue template when reporting a bug or requesting a new feature. Also please check first to see if there is an open issue that already covers your bug report or new feature request.

## Feature roadmap

In no particular order, and as a draft proposal:

- [ ] Automatic `Content-Type` header inference for requests.
- [ ] Customizable request parameter encoding strategies.
- [ ] Configurable response caching for requests.
- [ ] Multipart form data support.
- [ ] Configurable request retrying.
- [ ] Request authentication challenge handling.
- [ ] Comprehensive test coverage.
- [ ] Cocoapods support.

## License

APIota is completely open source and released under the MIT license. See [LICENSE.md](https://github.com/danielrbrowne/APIota/blob/master/LICENSE.md) for details if you want to use it in your own project(s).
