//
//  HomeViewModel+CollectionViewSetup.swift
//  ShowToStream
//
//  Created by Applify on 17/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension HomeViewModel {
    var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let weakSelf = self else {
                fatalError(StringConstants.badMemoryAccess)
            }
            switch sectionIndex {
            case 0:
                return weakSelf.setupTopBanner(section: sectionIndex)
            case 1:
                return weakSelf.setupContiueWatching(section: sectionIndex)
            case 2:
                return weakSelf.setupRecommendedForYou(section: sectionIndex)
            case weakSelf.numberOfSections - 3:
                return weakSelf.setupTop10(section: sectionIndex)
            case weakSelf.numberOfSections - 2:
                return weakSelf.setupPopularNow(section: sectionIndex)
            case weakSelf.numberOfSections - 1:
                return weakSelf.setupCategories(section: sectionIndex)
            default:
                let selectedCategorySectionIndex = sectionIndex - 3
                let items = weakSelf.selectedCategories[selectedCategorySectionIndex].show
                return weakSelf.setupCategoryItems(section: sectionIndex, items: items)
            }
        }
        return layout
    }
}

extension HomeViewModel {
    func headerViewSupplementaryItem(section: Int) -> NSCollectionLayoutBoundarySupplementaryItem  {
        
        var string = ""
        var font = UIFont.appLightFont(with: 32)
        
        switch section {
        case 0:
            string = ""
            font = UIFont.appLightFont(with: 0)
        case 1:
            string = StringConstants.continueWatching
            font = UIFont.appRegularFont(with: 18)
        case 2:
            string = StringConstants.recommendedForYou
            font = UIFont.appRegularFont(with: 18)
        case numberOfSections - 3:
            string = StringConstants.topRated
            font = UIFont.appSemiBoldFont(with: 14)
        case numberOfSections - 2:
            string = StringConstants.popularNow
            font = UIFont.appSemiBoldFont(with: 14)
        case numberOfSections - 1:
            string = StringConstants.categories
            font = UIFont.appSemiBoldFont(with: 14)
        default:
            let selectedCategorySectionIndex = section - 3
            string = selectedCategories[selectedCategorySectionIndex].title
            font = UIFont.appSemiBoldFont(with: 14)
        }
        
        let size = BaseHeaderCollectionReusableView.sizeWith(title: string,
                                                             font: font,
                                                             maxWidth: collectionView.frame.size.width - 30,
                                                             lineHeight: 44)
        let headerViewItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                            heightDimension: .absolute(size.height)),
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
        headerViewItem.pinToVisibleBounds = false
        return headerViewItem
    }
}

extension HomeViewModel {
    
    func setupTopBanner(section: Int) -> NSCollectionLayoutSection {
        let width = collectionView.frame.size.width
        let height = width
        return setupSection(with: section,
                            itemsArray: topBannerItems,
                            itemSize: CGSize(width: width, height: height),
                            requiresHeader: false,
                            sectionHorizontalInset: 0)
    }
    
    func setupContiueWatching(section: Int) -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 24 // 12 left, 12 right insets
        let width = (collectionViewConentWidth / 2.25)
        let height = width / 1.1
        return setupSection(with: section,
                            itemsArray: continueWatching,
                            itemSize: CGSize(width: width,
                                             height: height))
    }
    
    func setupRecommendedForYou(section: Int) -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 24 // 12 left, 12 right insets
        let width = (collectionViewConentWidth / 2.25)
        let height = width / 0.72
        return setupSection(with: section,
                            itemsArray: recommendedForYou,
                            itemSize: CGSize(width: width,
                                             height: height))
    }
    
    func setupTop10(section: Int) -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 24 // 12 left, 12 right insets
        let width = (collectionViewConentWidth / 3.35)
        let height = width / 0.72
        return setupSection(with: section,
                            itemsArray: top10,
                            itemSize: CGSize(width: width,
                                             height: height))
    }
    
    func setupPopularNow(section: Int) -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 24 // 12 left, 12 right insets
        let width = (collectionViewConentWidth / 3.35)
        let height = width / 0.72
        return setupSection(with: section,
                            itemsArray: popularNow,
                            itemSize: CGSize(width: width,
                                             height: height))
    }
    
    func setupCategories(section: Int) -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 24 // 12 left, 12 right insets
        let width = (collectionViewConentWidth / 2.25)
        let height = width / 2.56
        return setupSection(with: section,
                            itemsArray: categories,
                            itemSize: CGSize(width: width,
                                             height: height))
    }
    
    func setupCategoryItems(section: Int, items: [Any]) -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 24 // 12 left, 12 right insets
        let width = (collectionViewConentWidth / 3.35)
        return setupSection(with: section,
                            itemsArray: items,
                            itemSize: CGSize(width: width,
                                             height: width))
    }
    
    func setupSection(with sectionIndex: Int,
                      itemsArray: [Any],
                      itemSize: CGSize,
                      requiresHeader: Bool = true,
                      sectionHorizontalInset: CGFloat = 12.0) -> NSCollectionLayoutSection {
        // 1. Creating section layout. Item -> Group -> Section
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        var width = itemSize.width
        var height = itemSize.height
        if itemsArray.isEmpty {
            width = 0
            height = 0
        }
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(width),
                                                                                          heightDimension: .absolute(height)),
                                                       subitem: item, count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0,
                                                        leading: sectionHorizontalInset,
                                                        bottom: 0.0,
                                                        trailing: sectionHorizontalInset)
        // 2. Magic: Horizontal Scroll.
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
        // 3. Creating header layout
        if requiresHeader, !itemsArray.isEmpty {
            section.boundarySupplementaryItems = [headerViewSupplementaryItem(section: sectionIndex)]
        } else {
            section.boundarySupplementaryItems = []
        }
        return section
    }
}
