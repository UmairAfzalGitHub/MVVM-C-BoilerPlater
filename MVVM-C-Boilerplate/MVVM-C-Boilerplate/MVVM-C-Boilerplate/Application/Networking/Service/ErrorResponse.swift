
import Foundation

enum ErrorResponse: String {
    case noInternet
    case apiError
    case invalidEndpoint
    case invalidQueryItems
    case invalidParameter
    case invalidResponse
    case noData
    case general
    
    public var description: String {
        switch self {
        case .general:              return Strings.Error.general
        case .noInternet:           return Strings.Error.noInternet
        case .apiError:             return Strings.Error.apiError
        case .invalidEndpoint:      return Strings.Error.invalidEndpoint
        case .invalidQueryItems:    return Strings.Error.invalidQueryItems
        case .invalidParameter:     return Strings.Error.invalidParameter
        case .invalidResponse:      return Strings.Error.invalidResponse
        case .noData:               return Strings.Error.noData
        }
    }
}
