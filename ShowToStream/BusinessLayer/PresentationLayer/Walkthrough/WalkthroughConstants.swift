//
//  WalkthroughConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var walkthrough: UIStoryboard {
        return UIStoryboard(name: "Walkthrough", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let walkthrough          = "WalkthroughViewController"
}
