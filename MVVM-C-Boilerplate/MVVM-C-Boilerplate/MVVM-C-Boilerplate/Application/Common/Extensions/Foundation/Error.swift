
import Foundation

extension NSError {
    class func createError(domain: String? = nil, code: Int = 404, message: String?) -> NSError {
        return NSError(
            domain: domain ?? "com.api.error",
            code: code,
            userInfo: [NSLocalizedDescriptionKey : message ?? "####"]
        )
    }
    
    class func createError(ofType type: ErrorResponse) -> NSError {
        let error = NSError.createError(
            domain: type.rawValue,
            message: type.description
        )
        return error
    }
    
    class func createNetworkError() -> NSError {
        return NSError.createError(
            domain: ErrorResponse.noInternet.rawValue,
            message: ErrorResponse.noInternet.description
        )
    }
    
    class func createGerenalError() -> NSError {
        return NSError.createError(
            domain: ErrorResponse.general.rawValue,
            message: ErrorResponse.general.description
        )
    }
}
