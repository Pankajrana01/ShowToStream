//
//  HomeConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let home                 = "HomeViewController"
}

extension StringConstants {
    static let continueWatching     = "Continue Watching"
    static let recommendedForYou    = "Recommended For You"
    static let topRated             = "Top 10 Rated"
    static let popularNow           = "Popular Now"
    static let categories           = "Categories"
    static let viewMore             = "View More"
    static let heartGif             = "Heart.gif"
    static let badMemoryAccess      = " bad memory access "
}

extension CollectionViewCellIdentifier {
    static let collectionCell       = "CollectionViewCell"
    static let homeHeader           = "homeHeader"
    static let homeShow             = "homeShow"
    static let homeBannerShow       = "homeBannerShow"
    static let continueWatchingShow = "continueWatchingShow"
    static let bannerShow           = "bannerShow"
    static let viewMore             = "ViewMoreCollectionViewCell"
}

extension NibCellIdentifier{
    static let bannerShowCollectionViewCellNib     = "BannerShowCollectionViewCell"
    static let baseTileCollectionViewCellNib       = "BaseTileCollectionViewCell"
    static let homeShowCollectionViewCellNib       = "HomeShowCollectionViewCell"
    static let bannerShowsCollectionViewCellNib    = "BannerShowsCollectionViewCell"
    static let continueWatchingShowCollectionViewCellNib = "ContinueWatchingShowCollectionViewCell"
    static let baseHeaderCollectionReusableViewNib  = "BaseHeaderCollectionReusableView"
    static let viewMoreCollectionViewCell           = "ViewMoreCollectionViewCell"
}
enum HomeList: Int {
    case topBanner
    case recommendedForYou
    case selectedCategory
    case topRated
    case popularNow
    case categories

    var title: String? {
        switch self {
        case .topBanner:
            return nil
        case .recommendedForYou:
            return StringConstants.recommendedForYou
        case .selectedCategory:
            return "" // display the category name. controller specific customization
        case .topRated:
            return StringConstants.topRated
        case .popularNow:
            return StringConstants.popularNow
        case .categories:
            return StringConstants.categories
        }
    }
}
