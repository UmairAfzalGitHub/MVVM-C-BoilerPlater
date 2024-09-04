
import Foundation
import UIKit

extension UIViewController {

    func addCustomBackButton(with color: UIColor = .black) {
        let backButton: UIButton = UIButton (type: .custom)

        if color == .white {
            backButton.setImage(#imageLiteral(resourceName: "ic-back_white"), for: .normal)
            
        } else {
            backButton.setImage(#imageLiteral(resourceName: "ic-back"), for: .normal)
        }
        backButton.addTarget(self, action: #selector(self.backButtonPressed(button:)), for: UIControl.Event.touchUpInside)

        backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let barButton = UIBarButtonItem(customView: backButton)

        navigationItem.leftBarButtonItem = barButton
    }

    func addCustomCrossButton() {
        let crossButton: UIButton = UIButton (type: .custom)
        crossButton.setImage(UIImage(named: "cancel"), for: .normal)

        crossButton.addTarget(self, action: #selector(self.barCancelButtonTapped(button:)), for: .touchUpInside)

        crossButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: crossButton)

        navigationItem.rightBarButtonItem = barButton
    }

    @objc func backButtonPressed(button : UIButton) {

        if navigationController != nil {
            navigationController?.popViewController(animated: true)

        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func barCancelButtonTapped(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func topMostViewController() -> UIViewController {

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }

        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }

        if self.presentedViewController == nil {
            return self
        }

        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }

        if let tab = self.presentedViewController as? UITabBarController {

            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }

            return tab.topMostViewController()
        }

        return self.presentedViewController!.topMostViewController()
    }

    func dismissOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewControllerOnTap))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
    }

    @objc func dismissViewControllerOnTap(gesture: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
