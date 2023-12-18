//
//  WhoWatchingConstant.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 04/01/21.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var whoWatching: UIStoryboard {
        return UIStoryboard(name: "WhoWatching", bundle: nil)
    }
}

extension NibCellIdentifier{
    static let userProfileCollectionViewCellNib     = "UserProfileCollectionViewCell"
}

extension CollectionViewCellIdentifier {
    static let userProfileCollectionViewCell        = "UserProfileCollectionViewCell"
}

extension ViewControllerIdentifier {
    static let whoWatching                          = "WhoWatchingViewController"
}

extension StringConstants {
    static let ralphDibny                           = "Ralph Dibny"
    static let addNew                               = "Add New"
}
    
