//
//  ShowDetailConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var showDetail: UIStoryboard {
        return UIStoryboard(name: "ShowDetail", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let showDetail               = "ShowDetailViewController"
}

extension StringConstants {
    static let youMayAlsoLike           = "You May Also Like"
    static let watchlistAdded           = "Watchlist added successfully."
    static let contentReported          = "Thanks for reporting. We'll review your request and get back to you with in two business days."
    static let watchlistRemove          = "Watchlist removed successfully."
    static let accountRemove            = "Bank account removed successfully."
    static let selectAnotherAccount     = "Please select another bank account in order to make Default Account."
    static let watchList                = "watchlist"
    static let relatedShows             = "Related Shows"
}

extension CollectionViewCellIdentifier {
    static let showDescription          = "showDescription"
    static let similarShows             = "similarShows"
    static let showBanner               = "showBanner"

}

extension NibCellIdentifier {
    static let showBannerCollectionViewCellNib       = "ShowBannerCollectionViewCell"
    static let showDescriptionCollectionViewCellNib  = "ShowDescriptionCollectionViewCell"
}
