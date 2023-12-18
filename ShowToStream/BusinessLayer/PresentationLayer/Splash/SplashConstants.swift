//
//  SplashConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var splash: UIStoryboard {
        return UIStoryboard(name: "Splash", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let splash               = "SplashViewController"
}
