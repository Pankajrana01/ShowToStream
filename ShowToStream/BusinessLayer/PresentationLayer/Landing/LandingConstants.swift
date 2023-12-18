//
//  LandingConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var landing: UIStoryboard {
        return UIStoryboard(name: "Landing", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let landing              = "LandingViewController"
}

enum TabItem: Int {
    case home
    case search
    case watchlist
    
    var icon: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "Home")
        case .search:
            return #imageLiteral(resourceName: "Search")
        case .watchlist:
            return #imageLiteral(resourceName: "Watchlist")
        }
    }
    
    var selectedIcon: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "HomeActive")
        case .search:
            return #imageLiteral(resourceName: "SearchActive")
        case .watchlist:
            return #imageLiteral(resourceName: "WatchlistActive")
        }
    }
}
