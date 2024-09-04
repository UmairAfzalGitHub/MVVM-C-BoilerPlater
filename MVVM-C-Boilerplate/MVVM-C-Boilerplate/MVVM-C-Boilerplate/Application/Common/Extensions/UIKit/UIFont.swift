
import Foundation
import UIKit

extension UIFont {

    class func appThemeFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "UberMove-Regular", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func appThemeBoldFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "UberMove-Bold", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }
    
    class func appThemeMediumFontWithSize(_ fontSize: CGFloat) -> UIFont {
        
        if let font = UIFont(name: "UberMove-Medium", size: fontSize) {
            return font
        }
        
        return UIFont.systemFont(ofSize: fontSize)
    }

    class func sevenSegmentFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "DBVTDTempBlack", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

}

enum FontTypeface: String{
    case bold
    case semiBold
    case medium
    case regular
}
