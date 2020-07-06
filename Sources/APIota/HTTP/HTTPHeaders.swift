import Foundation

/// Defines storage for a collection of `HTTPHeader`s for use in a `URLRequest`.
///
/// An instance can be initialized using a dictionary literal
/// (e.g. `headers = [.contentType: HTTPMediaType.json.stringValue()]`).
public struct HTTPHeaders {

    private var headers: [HTTPHeader: String]

    // MARK: - Header access

    public var allHTTPHeaderFields: [String: String] {
        return headers.reduce(into: [String: String]()) { stringDictionary, headersDictionary in
            stringDictionary[headersDictionary.key.stringValue] = headersDictionary.value
        }
    }

    public mutating func replaceOrAdd(header: HTTPHeader, value: String) {
        headers.updateValue(value, forKey: header)
    }

    public mutating func remove(header: HTTPHeader) {
        headers.removeValue(forKey: header)
    }

    public func value(for header: HTTPHeader) -> String? {
        return headers[header]
    }
}

// MARK: - ExpressibleByDictionaryLiteral conformance

extension HTTPHeaders: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (HTTPHeader, String)...) {

        let headers = elements.reduce(into: [HTTPHeader: String]()) { resultDict, headerValueTuple in
            resultDict[headerValueTuple.0] = headerValueTuple.1
        }
        self = HTTPHeaders(headers: headers)
    }
}
