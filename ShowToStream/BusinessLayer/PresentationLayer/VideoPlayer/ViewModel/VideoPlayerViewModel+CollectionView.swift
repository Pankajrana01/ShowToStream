//
//  VideoPlayerViewModel+CollectionView.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 15/03/21.
//

import Foundation
import UIKit

extension VideoPlayerViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: CollectionViewCellIdentifier.homeHeader,
                                                                   for: indexPath) as! BaseHeaderCollectionReusableView
        view.title = StringConstants.relatedShows
        view.titleFont = UIFont.appSemiBoldFont(with: 14)
        view.titleColor = .white
        view.titleLeftPadding = 0
//        view.backgroundColor = UIColor.red
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getSimilarShowsCell(with: indexPath, show: similarShows[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
//            stopPlayingTrailerVideo()
//            stopPlayingVideo()
        ShowDetailViewController.show(from: self.hostViewController, show: similarShows[indexPath.item], isCome:StringConstants.relatedShows, universal_showId: "")
        
    }

    private func getSimilarShowsCell(with indexPath: IndexPath, show: Show, cellCornerRadius: CGFloat = 4) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.similarShows,
                                                      for: indexPath) as! HomeShowCollectionViewCell
        cell.show = show
        cell.containerCornerRadius = cellCornerRadius
        return cell
    }
}
