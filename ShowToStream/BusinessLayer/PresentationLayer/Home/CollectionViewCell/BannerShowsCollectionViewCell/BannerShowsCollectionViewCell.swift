//
//  BannerShowsCollectionViewCell.swift
//  ShowToStream
//
//  Created by Applify on 17/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class BannerShowsCollectionViewCell: UICollectionViewCell {
    var heartButtonAction:  ((Int) -> Bool)?
    var infoButtonAction:   ((Int) -> Void)?
    var playButtonAction:   ((Int) -> Void)?
    
    
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var viewController: BaseViewController!
    var shows: [Show]! { didSet { showsDidSet() } }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    private func showsDidSet() {
        pageControl.numberOfPages = shows.count
        pageControl.isHidden = shows.count < 2
        collectionView.register(UINib(nibName: NibCellIdentifier.bannerShowCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.bannerShow)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
    }
    
    func setPageControlCurrentPage(page: Int) {
        pageControl.currentPage = page
    }

}

extension BannerShowsCollectionViewCell: TrailerPlayerInCollectionViewCell {
    func playTrailer(in viewController: BaseViewController) {
        self.viewController = viewController
        collectionView.visibleCells.forEach { ($0 as? TrailerPlayerInCollectionViewCell)?.playTrailer(in: viewController) }
    }
    
    func stopPlayingTrailer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        collectionView.visibleCells.forEach { ($0 as? TrailerPlayerInCollectionViewCell)?.stopPlayingTrailer() }
    }
}
