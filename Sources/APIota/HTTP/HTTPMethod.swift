import Foundation

// Referenced from: https://www.iana.org/assignments/http-methods/http-methods.xhtml#methods

public enum HTTPMethod: String {
    case ACL
    case BASELINECONTROL
    case BIND
    case CHECKIN
    case CHECKOUT
    case CONNECT
    case COPY
    case DELETE
    case GET
    case HEAD
    case LABEL
    case LINK
    case LOCK
    case MERGE
    case MKACTIVITY
    case MKCALENDAR
    case MKCOL
    case MKREDIRECTREF
    case MKWORKSPACE
    case MOVE
    case OPTIONS
    case ORDERPATCH
    case PATCH
    case POST
    case PRI
    case PROPFIND
    case PROPPATCH
    case PUT
    case REBIND
    case REPORT
    case SEARCH
    case TRACE
    case UNBIND
    case UNCHECKOUT
    case UNLINK
    case UNLOCK
    case UPDATE
    case UPDATEREDIRECTREF
    case VERSIONCONTROL
}
