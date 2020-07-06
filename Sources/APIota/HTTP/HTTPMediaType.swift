import Foundation

/// Describes media types for the `Content-Type` HTTP header.
///
/// Also contains a number of default media types,
/// defined according to: https://tools.ietf.org/html/rfc2045#section-5
public struct HTTPMediaType {

    // MARK: - Enum definitions

    public enum TypeIdentifier: String {
        case any
        case application
        case audio
        case image
        case message
        case multipart
        case text
        case video
    }

    // MARK: - Private variables

    private let type: TypeIdentifier

    private let subType: String

    private let parameters: [String: String]?

    // MARK: - Initialization

    public init(type: TypeIdentifier,
                subType: String,
                parameters: [String: String]? = nil) {
        self.type = type
        self.subType = subType
        self.parameters = parameters
    }

    // MARK: - Public methods

    public func toString() -> String {
        var stringRepresentation = "\(type)/\(subType)"

        guard let parameters = parameters else {
            return stringRepresentation
        }

        for (parameter, value) in parameters {
            stringRepresentation += "; \(parameter)=\(value)"
        }

        return stringRepresentation
    }
}

// MARK: - Default media type values

extension HTTPMediaType {

    // UTF-8 charset

    static let utf8CharsetParameter = ["charset": "utf-8"]

    // any

    static let any = HTTPMediaType(type: .any, subType: "*")

    // application

    static let binary = HTTPMediaType(type: .application, subType: "octet-stream")

    static let bzip2 = HTTPMediaType(type: .application, subType: "x-bzip2")

    static let gzip = HTTPMediaType(type: .application, subType: "x-bzip2")

    static let dtd = HTTPMediaType(type: .application,
                                   subType: "xml-dtd",
                                   parameters: utf8CharsetParameter)

    static let json = HTTPMediaType(type: .application, subType: "json")

    static let jsonAPI = HTTPMediaType(type: .application,
                                       subType: "vnd.api+json",
                                       parameters: utf8CharsetParameter)

    static let pdf = HTTPMediaType(type: .application, subType: "pdf")

    static let tar = HTTPMediaType(type: .application, subType: "x-tar")

    static let urlEncodedForm = HTTPMediaType(type: .application,
                                              subType: "x-www-form-urlencoded",
                                              parameters: utf8CharsetParameter)

    static let xml = HTTPMediaType(type: .application,
                                   subType: "xml",
                                   parameters: utf8CharsetParameter)

    static let zip = HTTPMediaType(type: .application, subType: "zip")

    // audio

    static let audio = HTTPMediaType(type: .audio, subType: "basic")

    static let midi = HTTPMediaType(type: .audio, subType: "x-midi")

    static let mp3 = HTTPMediaType(type: .audio, subType: "mpeg")

    static let wav = HTTPMediaType(type: .audio, subType: "wav")

    static let ogg = HTTPMediaType(type: .audio, subType: "vorbis")

    // image

    static let gif = HTTPMediaType(type: .image, subType: "gif")

    static let jpeg = HTTPMediaType(type: .image, subType: "jpeg")

    static let png = HTTPMediaType(type: .image, subType: "png")

    static let svg = HTTPMediaType(type: .image, subType: "svg+xml")

    // message

    // multipart

    static let multipartFormData = HTTPMediaType(type: .multipart, subType: "form-data")

    static func multipartFormData(boundary: String) -> HTTPMediaType {
        return HTTPMediaType(type: .multipart,
                             subType: "form-data",
                             parameters: ["boundary": boundary])
    }

    // text

    static let css = HTTPMediaType(type: .text,
                                   subType: "css",
                                   parameters: utf8CharsetParameter)

    static let html = HTTPMediaType(type: .text,
                                    subType: "html",
                                    parameters: utf8CharsetParameter)

    static let plainText = HTTPMediaType(type: .text,
                                         subType: "plain",
                                         parameters: utf8CharsetParameter)

    // video

    static let avi = HTTPMediaType(type: .video, subType: "avi")

    static let mpeg = HTTPMediaType(type: .video, subType: "mpeg")
}

// MARK: - Equatable conformance

extension HTTPMediaType: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.type == .any && rhs.type == .any {
            return true
        }
        
        if lhs.type != rhs.type {
            return false
        }

        return lhs.subType == "*"
            || rhs.subType == "*"
            || lhs.subType.caseInsensitiveCompare(rhs.subType) == .orderedSame
    }
}

// MARK: - CustomStringConvertible conformance

extension HTTPMediaType: CustomStringConvertible {

    public var description: String {
        return toString()
    }
}
