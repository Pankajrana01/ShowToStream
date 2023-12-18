//
//  VideoPlayerViewModel+CollectionViewSetup.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 15/03/21.
//

import Foundation
import UIKit

extension VideoPlayerViewModel {
    var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let weakSelf = self else {
                fatalError(StringConstants.badMemoryAccess)
            }
          
            return weakSelf.setupSimilarShows()
            
        }
        return layout
    }
}

extension VideoPlayerViewModel {
    func headerViewSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem  {
        let size = BaseHeaderCollectionReusableView.sizeWith(title: StringConstants.relatedShows,
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

extension VideoPlayerViewModel {

    func setupSimilarShows() -> NSCollectionLayoutSection {
        let collectionViewConentWidth = collectionView.frame.size.width - 24 // 12 left, 12 right insets
        let width = (collectionViewConentWidth / 4.00)
        let height = width / 1.50
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
