//
//  SearchConstants.swift
//  ShowToStream
//
//  Created by Applify on 05/01/21.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var search: UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let search                   = "SearchViewController"
}

extension CollectionViewCellIdentifier {
    static let topSearch                = "topSearch"
    static let searchedShow             = "searchedShow"
    static let searchHeader             = "searchHeader"
    static let recentSearch             = "recentSearch"
}

extension StringConstants {
    static let exploreByCategory        = "Explore By Category"
    static let recentSearch             = "Recent Searches"
    static let exploreByGenre           = "What you like"
    static let topSearches              = "Top Searches"
    static let search                   = "Search"
    static let theSwanLake              = "The Swan Lake"
    static let cats                     = "Cats"
    static let hamlet                   = "Hamlet"
    static let myFairLady               = "My Fair Lady"
    static let topSearchCollectionViewCellNib = "TopSearchCollectionViewCell"
    static let searchedShowCollectionViewCellNib = "SearchedShowCollectionViewCell"
    static let recentSearchCollectionViewCellNib = "RecentSearchCollectionViewCell"
}
