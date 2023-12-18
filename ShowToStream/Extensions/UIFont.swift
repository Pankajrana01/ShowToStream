//
//  UIFont.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

// MARK: - UIFont Extension
extension UIFont {
        
    class func appBlackFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Black",
                      size: size)!
    }

    class func appBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Bold",
                      size: size)!
    }

    class func appExtraBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-ExtraBold",
                      size: size)!
    }

    class func appExtraLightFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-ExtraLight",
                      size: size)!
    }

    class func appLightFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Light",
                      size: size)!
    }

    class func appMediumFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Medium",
                      size: size)!
    }

    class func appRegularFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Regular",
                      size: size)!
    }

    class func appSemiBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-SemiBold",
                      size: size)!
    }

    class func appThinFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Thin",
                      size: size)!
    }
    
}
