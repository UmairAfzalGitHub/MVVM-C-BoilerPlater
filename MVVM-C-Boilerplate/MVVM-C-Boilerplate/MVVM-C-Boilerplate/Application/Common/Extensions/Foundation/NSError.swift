
import Foundation
import UIKit

let TBErrorDomain = "com.errordomain.TB"
let TBFormErrorCode = 40001
typealias TBAlertCompletionHandler = (_ retry: Bool, _ cancel: Bool) -> Void

extension NSError {

    func showAlert(message: String? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message ?? localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    class func showErrorWithMessage(message: String, viewController: UIViewController, type: TBMessageType = .error, topConstraint: CGFloat = 0.0) {
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

enum TBMessageType: Int {
    case error = 0
    case success
    case info
}
