import Foundation

/// Defines storage for a collection of `HTTPHeader`s for use in a `URLRequest`.
///
/// An instance can be initialized using a dictionary literal
/// (e.g. `headers = [.contentType: HTTPMediaType.json.stringValue()]`).
public struct HTTPHeaders {

    private var headers: [HTTPHeader: String]

    // MARK: - Header access

    /// A `Dictionary` representation of all contained header fields within the receiver.
    public var allHTTPHeaderFields: [String: String] {
        return headers.reduce(into: [String: String]()) { stringDictionary, headersDictionary in
            stringDictionary[headersDictionary.key.stringValue] = headersDictionary.value
        }
    }

    /// Replace the current value for a given `HTTPHeader` with a new value
    /// (or adds it to the receiver if a header with the same name was not already present).
    /// - Parameters:
    ///   - header: The `HTTPHeader` whose corresponding value should be replaced or set.
    ///   - value: The `String` value to associated with a given header.
    public mutating func replaceOrAdd(header: HTTPHeader, value: String) {
        headers.updateValue(value, forKey: header)
    }

    /// Remove a `HTTPHeader` (and its corresponding value) if it exists in the receiver.
    /// (This method has no effect if no header with a given name exists in the receiver).
    /// - Parameter header: The `HTTPHeader` to remove from the receiver.
    public mutating func remove(header: HTTPHeader) {
        headers.removeValue(forKey: header)
    }

    /// Retrieves the value for a given `HTTPHeader` (if it is present in the receiver).
    /// - Parameter header: The `HTTPHeader` to inspect.
    /// - Returns: The `String` value for the corresponding header (if it was present).
    public func value(for header: HTTPHeader) -> String? {
        return headers[header]
    }
}

// MARK: - ExpressibleByDictionaryLiteral conformance

extension HTTPHeaders: ExpressibleByDictionaryLiteral {

    /// Initializes a `HTTPHeaders` based on a `Dictionary` literal.
    /// - Parameter elements: A `Dictionary` literal (e.g. `[.contentType: "application/json"]`).
    public init(dictionaryLiteral elements: (HTTPHeader, String)...) {

        let headers = elements.reduce(into: [HTTPHeader: String]()) { resultDict, headerValueTuple in
            resultDict[headerValueTuple.0] = headerValueTuple.1
        }
        self = HTTPHeaders(headers: headers)
    }
}
