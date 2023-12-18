//
//  UILabel.swift
//  ShowToStream
//
//  Created by Applify on 16/12/20.
//

import UIKit

@IBDesignable
extension UILabel {
    
    @IBInspectable
    var lineHeight: CGFloat {
        get {
            return 20
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = newValue
            paragraphStyle.maximumLineHeight = newValue
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineBreakMode = self.lineBreakMode
            
            let attrString = NSMutableAttributedString(string: text!)
            attrString.addAttribute(NSAttributedString.Key.font, value: font!, range: NSRange(location: 0, length: attrString.length))
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            attributedText = attrString
        }
    }

}
