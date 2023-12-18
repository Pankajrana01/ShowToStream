//
//  WatchlistConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var watchlist: UIStoryboard {
        return UIStoryboard(name: "Watchlist", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let watchlist                = "WatchlistViewController"
}

extension TableViewNibIdentifier {
    static let watchlistCell            = "WatchlistTableViewCell"
    static let continueWatching         = "ContinueWatchingTableViewCell"
}

extension TableViewCellIdentifier {
    static let watchlistCell            = "watchlistCell"
    static let continueWatching         = "ContinueWatchingTableViewCell"
}

extension StringConstants {
    static let remove                   = "Remove"
    static let removeWatchlistConfirm   = "Are you sure you want to Remove?"
    static let no                       = "No"
    static let youHaveNotAddedAnyShows  = "You haven’t added any shows yet.\nTap the ♡ icon to wishlist videos to watch them later"
    static let noVideoFound             = "No Video Found"
    static let feelLonelyHere           = "Feels lonely here"
}
