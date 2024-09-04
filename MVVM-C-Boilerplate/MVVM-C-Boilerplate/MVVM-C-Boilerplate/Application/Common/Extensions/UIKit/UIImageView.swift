

import UIKit

extension UIImageView {

    func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: frame.size.width/2, y: frame.size.height/2, width: 30, height: 30))
        activityIndicator.tag = 6565
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        self.bringSubviewToFront(activityIndicator)
    }

    func stopActivityIndicator() {

        if let activityInficator = self.viewWithTag(6565) {
            activityInficator.removeFromSuperview()
        }
    }
}
