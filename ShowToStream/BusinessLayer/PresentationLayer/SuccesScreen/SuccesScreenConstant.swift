//
//  SuccesScreenConstant.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 23/12/20.
//

import Foundation
import UIKit
extension UIStoryboard {
    
    class var succesScreen: UIStoryboard {
        return UIStoryboard(name: "SuccesScreen", bundle: nil)
    }
}
extension ViewControllerIdentifier {
    static let succesScreen                   = "SuccesScreenViewController"
}

extension StringConstants {
    static let succesScreen                    = "succesScreen"
    
}

extension ValidationError {
    
}

extension SucessMessage {
    
}
