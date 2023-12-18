//
//  BannerShowsCollectionViewCell+CollectionView.swift
//  ShowToStream
//
//  Created by Applify on 18/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
extension BannerShowsCollectionViewCell: UICollisionBehaviorDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.bannerShow,
                                                      for: indexPath) as! BannerShowCollectionViewCell
        cell.show = shows[indexPath.item]
        cell.playButtonAction = {
            self.playButtonAction?(indexPath.item)
        }
        cell.heartButtonAction = {
            self.heartButtonAction!(indexPath.item)
        }
        cell.infoButtonAction = {
            self.infoButtonAction?(indexPath.item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        setPageControlCurrentPage(page: Int(pageNumber))
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? TrailerPlayerInCollectionViewCell {
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.playVideo(cell:)), object: cell)
            
          //  perform(#selector(self.playVideo(cell:)), with: cell, afterDelay: TrailerPlayDelay)
        }
    }
    
    @objc
    func playVideo(cell: TrailerPlayerInCollectionViewCell) {
        cell.playTrailer(in: viewController)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? TrailerPlayerInCollectionViewCell {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.playVideo(cell:)), object: cell)
            cell.stopPlayingTrailer()
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.infoButtonAction?(indexPath.item)
    }
}


