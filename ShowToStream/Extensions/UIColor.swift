//
//  UIColor.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var appGray: UIColor {
        return UIColor(named: "AppGray")!
    }

    class var appOffWhite: UIColor {
        return UIColor(named: "AppOffWhite")!
    }

    class var appVoiletBackground: UIColor {
        return UIColor(named: "AppVoiletBackground")!
    }

    class var appVoilet: UIColor {
        return UIColor(named: "AppVoilet")!
    }

    class var appVoiletDark: UIColor {
        return UIColor(named: "AppVoiletDark")!
    }

    class var appLightBlack: UIColor {
        return UIColor(named: "AppLightBlack")!
    }

    class var appYellow: UIColor {
        return UIColor(named: "AppYellow")!
    }
    class var appLightGray: UIColor {
        return UIColor(named: "AppLightGray")!
    }
    
    class var appDarkRed: UIColor {
        return UIColor(named: "AppDarkRed")!
    }

    class var appLightRed: UIColor {
        return UIColor(named: "AppLightRed")!
    }
    
    class var appPlaceholder: UIColor {
        return UIColor(named: "AppPlaceholder")!
    }

    class var appSeparator: UIColor {
        return UIColor(named: "AppSeparator")!
    }
    
    class var appAlertOpacity: UIColor {
        return UIColor(named: "AppAlertOpacity")!
    }
    
    class var appLightGrey: UIColor {
        return UIColor(named: "AppLightGrey")!
    }
    
    class var appSearchBorder:UIColor {
        return UIColor(named: "AppSearchBorder")!
    }
    
    class var appContainerViewBackgroud:UIColor {
        return UIColor(named: "AppContainerViewBackgroud")!
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                var rgbValue:UInt64 = 0
                Scanner(string: hexColor).scanHexInt64(&rgbValue)
                
                r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgbValue & 0x0000FF) / 255.0
                a = CGFloat(1.0)

                self.init(red: r, green: g, blue: b, alpha: a)
                return

            }
        }
        return nil
    }
    
}
