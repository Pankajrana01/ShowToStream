//
//  String.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension String {
    var isLocalImageUrl: Bool {
        return !self.contains("http") && !self.contains("www.")
    }
}

extension String {
//    func sha1() -> String {
//        let data = Data(self.utf8)
//        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
//        data.withUnsafeBytes {
//            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
//        }
//        let hexBytes = digest.map { String(format: "%02hhx", $0) }
//        return hexBytes.joined()
//    }

    var isValidEmailAddress: Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
            if results.isEmpty {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    var isValidPasswordWithSpecialChracter: Bool {
        var returnValue = true
        //@$!%*#?&/
        let emailRegEx = "^(?=.*[a-z0-9A-Z])(?=.*[$@$#!%*?&/]).{6,}$"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
            if results.isEmpty {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    var isValidPhoneNumber: Bool {
        var returnValue = true
        let emailRegEx =  "[^0]{5}$"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
            if results.isEmpty {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    var isValidName: Bool {
        return !isEmpty && range(of: "[^a-zA-Z 0-9]", options: .regularExpression) == nil
    }
    
    var isValidProfileName: Bool {
        return !isEmpty && range(of: "[^a-zA-Z 0-9]", options: .regularExpression) == nil
    }

    var isValidMobileNumber: Bool {
        return self.count > 5 && self.count < 16
    }

    var isValidMobileNumberWithZero: Bool {
        return self.count > 6 && self.count < 17
    }
    
    var isValidPassword: Bool {
        return !isEmpty && self.count >= 6 && self.count <= 20
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        if rangeOfCharacter(from: notDigits,
                            options: String.CompareOptions.literal,
                            range: nil) == nil {
            return true
        }
        return false
    }
    
    var isNumericValue: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    var isAlphabetValue: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}

extension String {
    func width(with font: UIFont,
               padding: CGFloat = 0,
               maxWidth: CGFloat = 1000) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        let width = size.width + padding
        return width < maxWidth ? width : maxWidth
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineHeight: CGFloat = 20) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func size(with font: UIFont, maxWidth: CGFloat = 1000, lineHeight: CGFloat = 20) -> CGSize {
        let height = self.height(withConstrainedWidth: maxWidth, font: font, lineHeight: lineHeight)
        let width = self.width(withConstrainedHeight: height, font: font)
        let size = CGSize(width: width, height: height)
        return size
    }
}


extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    var boolValue: Bool {
        return self == "true" || self == "1" || self == "YES"
    }
}
extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }

    func subString(at: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: at)
        let endIndex = self.index(self.startIndex, offsetBy: at)
        return String(self[startIndex...endIndex])
    }
}
extension String {
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
}

extension String {
    var currencyAppended: String {
        return "$ \(self)"
    }
}
