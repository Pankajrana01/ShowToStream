//
//  UIStoryboard.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {

    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func initialViewController() -> UIViewController {
        if let initialVC = self.instantiateInitialViewController() {
            return initialVC
        }
        fatalError("Could Not Instantiate Initial View Controller. Make Sure Some View Controller Is Set Initial View Controller In Storyboard")
    }
}
