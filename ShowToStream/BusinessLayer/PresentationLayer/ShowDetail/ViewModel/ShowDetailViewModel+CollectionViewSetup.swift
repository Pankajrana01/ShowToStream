//
//  ShowDetailViewModel+CollectionViewSetup.swift
//  ShowToStream
//
//  Created by Applify on 21/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension ShowDetailViewModel {
    var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let weakSelf = self else {
                fatalError(StringConstants.badMemoryAccess)
            }
            switch sectionIndex {
            case 0:
                return weakSelf.setupTopBanner()
            case 1:
                return weakSelf.setupShowDescription()
            case 2:
                return weakSelf.setupSimilarShows()
            default:
                fatalError("invalid section")
            }
        }
        return layout
    }
}

extension ShowDetailViewModel {
    func headerViewSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem  {
        let size = BaseHeaderCollectionReusableView.sizeWith(title: StringConstants.youMayAlsoLike,
                                                             font:  UIFont.appSemiBoldFont(with: 14),
                                                             maxWidth: collectionView.frame.size.width - 30,
                                                             lineHeight: 44)
        let headerViewItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                            heightDimension: .absolute(size.height)),
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
        headerViewItem.pinToVisibleBounds = true
        return headerViewItem
    }
}

extension ShowDetailViewModel {
    
    // in the designs, in home screen, the top banner is square, where we will autoplay the video trailer. But in detail screen designs, the banner is not square, but the video will be played here too. so keeping both the same.
    func setupTopBanner() -> NSCollectionLayoutSection {
        let width = collectionView.frame.size.width
        let height = width * 0.5625
        return setupSection(itemsArray: [show!],
                            itemSize: CGSize(width: width, height: height),
//                            itemSize: nil, // to make cell take height of the image, send nil.
                            requiresHeader: false,
                            sectionHorizontalInset: 0)
    }
    
    func setupShowDescription() -> NSCollectionLayoutSection {
        return setupSection(itemsArray: [show!],
                            itemSize: nil,
                            requiresHeader: false,
                            sectionHorizontalInset: 0)  
//                            sectionHorizontalScroll: false)
    }
    
    func setupSimilarShows() -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 20 // 10 left, 10 right insets
        let width = (collectionViewConentWidth / 3.35)
        let height = width / 0.72
        return setupSection(itemsArray: similarShows,
                            itemSize: CGSize(width: width, height: height))
    }
    
    func setupSection(itemsArray: [Any],
                      itemSize: CGSize?,
                      requiresHeader: Bool = true,
                      sectionHorizontalScroll: Bool = true,
                      sectionHorizontalInset: CGFloat = 10.0) -> NSCollectionLayoutSection {
        
        let itemlayoutSize: NSCollectionLayoutSize
        let grouplayoutSize: NSCollectionLayoutSize
        if let itemSize = itemSize {
            itemlayoutSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.fractionalHeight(1)
            )
            
            var width = itemSize.width
            var height = itemSize.height
            if itemsArray.isEmpty {
                width = 0
                height = 0
            }
            grouplayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(width),
                                                     heightDimension: .absolute(height))

        } else {
            
            let size = NSCollectionLayoutSize(
//                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1-(10/collectionView.frame.size.width)),
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.estimated(1)
            )
            itemlayoutSize = size
            grouplayoutSize = size
        }
        
        // 1. Creating section layout. Item -> Group -> Section
        // Item
        let item = NSCollectionLayoutItem(layoutSize: itemlayoutSize)
        
        // Group
        let group: NSCollectionLayoutGroup
        if sectionHorizontalScroll {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: grouplayoutSize,
                                                           subitem: item, count: 1)
        } else {
            group = NSCollectionLayoutGroup.vertical(layoutSize: grouplayoutSize,
                                                           subitem: item, count: 1)
        }
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0,
                                                        leading: sectionHorizontalInset,
                                                        bottom: 0.0,
                                                        trailing: sectionHorizontalInset)
        // 2. Magic: Horizontal Scroll.
        if itemSize != nil {
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
        }
        
        // 3. Creating header layout
        if requiresHeader, !itemsArray.isEmpty {
            section.boundarySupplementaryItems = [headerViewSupplementaryItem()]
        } else {
            section.boundarySupplementaryItems = []
        }
        return section
    }
}
