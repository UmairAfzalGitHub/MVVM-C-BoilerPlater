
import UIKit
import Foundation

extension String {
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
    
    var length: Int {
        return self.count
    }
    
    func fromBase64() -> String
    {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    func toBase64() -> String
    {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        let result =  emailPredicate.evaluate(with: self)
        
        return result
        
    }
    
    func isValidPassword() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        
        if rangeOfCharacter(from: characterset.inverted) != nil && length >= 8 {
            return true
            
        } else {
            return false
        }
    }

    static func makeTextBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {
        
        let boldAttrs = [NSAttributedString.Key.font: UIFont.appThemeBoldFontWithSize(fontSzie) as AnyObject]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs as [NSAttributedString.Key:AnyObject])
        
        let lightAttr = [NSAttributedString.Key.font: UIFont.appThemeFontWithSize(fontSzie) as AnyObject]
        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr as [NSAttributedString.Key:AnyObject])
        
        let postText = NSMutableAttributedString(string:postBoldText, attributes:lightAttr as [NSAttributedString.Key:AnyObject])
        
        finalAttributedText.append(attributedString)
        finalAttributedText.append(postText)
        
        return finalAttributedText
    }
    
    static func makeTextSemiBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {
        
        let boldAttrs = [NSAttributedString.Key.font : UIFont.appThemeMediumFontWithSize(fontSzie) as AnyObject]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs as [NSAttributedString.Key:AnyObject])
        
        let lightAttr = [NSAttributedString.Key.font : UIFont.appThemeFontWithSize(fontSzie) as AnyObject]
        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr as [NSAttributedString.Key:AnyObject])
        
        let postText = NSMutableAttributedString(string:postBoldText, attributes:lightAttr as [NSAttributedString.Key:AnyObject])
        
        finalAttributedText.append(attributedString)
        finalAttributedText.append(postText)
        
        return finalAttributedText
    }

    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) { return self }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func grouping(every groupSize: Int, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? self
    }
}
