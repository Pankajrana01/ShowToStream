//
//  ShowDetailViewModel+CollectionView.swift
//  ShowToStream
//
//  Created by Applify on 18/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension ShowDetailViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            fallthrough
        case 1:
            return 1
        default:
            return similarShows.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: CollectionViewCellIdentifier.homeHeader,
                                                                   for: indexPath) as! BaseHeaderCollectionReusableView
        view.title = StringConstants.youMayAlsoLike
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            view.titleFont = UIFont.appSemiBoldFont(with: 18)
        }else{
            view.titleFont = UIFont.appSemiBoldFont(with: 14)
        }
        
        view.titleColor = .white
        view.titleLeftPadding = 0
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return getTopBannerCell(indexPath: indexPath)
        case 1:
            return getShowDescriptionCell(indexPath: indexPath)
        case 2:
            return getSimilarShowsCell(with: indexPath, show: similarShows[indexPath.item])
        default:
            fatalError("invalid section")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            stopPlayingTrailerVideo()
            stopPlayingVideo()
            ShowDetailViewController.show(from: self.hostViewController, show: similarShows[indexPath.item], isCome: "", universal_showId: "")
        }
    }

    private func getTopBannerCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.showBanner,
                                                      for: indexPath) as! ShowBannerCollectionViewCell
        cell.show = show
        cell.similarShows = similarShows
        cell.watchNowAction = {
            self.watchNowButtonTapped()
        }
        return cell
    }

    private func getShowDescriptionCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.showDescription,
                                                      for: indexPath) as! ShowDescriptionCollectionViewCell
        cell.showFullDescription = showFullDescription
        cell.show = show
        
//        cell.shareButtonAction = {
//            self.shareShow(showName: self.show.title!)
//        }
        
        cell.watchlistButtonAction = {
            if !self.sessionCreated {
                self.checkforAccount()
            }else{
                if !self.show.addedToWatchlist {
                    cell.addToWatchList.text = WebConstants.addedtoWatchlist
                    cell.heartGifImageView.isHidden = false
                    if let gif = try? UIImage(gifName: StringConstants.heartGif) {
                        cell.heartGifImageView.setGifImage(gif, loopCount: 1)
                        self.processDataForAddToWatchList(contentId: self.show._id!)
                        
                    }
                    
                } else {
                    cell.addToWatchList.text = WebConstants.addtoWatchlist
                    cell.heartGifImageView.isHidden = true
                    cell.heartImageView.image = #imageLiteral(resourceName: "Heart")
                    let params: [String: Any] = [WebConstants.contentId: self.show._id!]
                    self.processDataForRemoveWatchList(params: params)
                }
               
            }
        }
        if !self.sessionCreated {
            cell.show.addedToWatchlist = false
//            cell.heartGifImageView.isHidden = true
//            cell.heartImageView.image = #imageLiteral(resourceName: "Heart")
//            cell.addToWatchList.text = WebConstants.addtoWatchlist
        }
        cell.reportButtonAction = {
            if !self.sessionCreated {
                self.checkforAccount()
            }else{
                self.processDataForReport(contentId: self.show._id!)
            }
        }
        
        cell.toggleDescriptionButtonAction = {
            self.showFullDescription.toggle()

            let offsetBeforeReload = self.collectionView.contentOffset
            UIView.performWithoutAnimation {
                self.collectionView.reloadSections([1])
                self.collectionView.setContentOffset(offsetBeforeReload, animated: false)
            }
            if (offsetBeforeReload.y + self.collectionView.bounds.size.height) > self.collectionView.contentSize.height {
               // let finalOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - self.collectionView.bounds.size.height)
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3) {
                        self.collectionView.contentOffset = CGPoint(x: 0.0,y: 0.0)
                    }
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoPlayerInCollectionViewCell {
//            if !show.isPurchased {
//                perform(#selector(self.autpPlayTrailer(cell:)), with: cell, afterDelay: TrailerPlayDelay)
//            }else{
//                perform(#selector(self.autpPlayVideo(cell:)), with: cell, afterDelay: TrailerPlayDelay)
//            }
        }
    }
    
    @objc
    func autpPlayTrailer(cell: VideoPlayerInCollectionViewCell) {
        if self.hostViewController != nil{
           // cell.stopPlayingVideo()
            cell.playTrailer(in: self.hostViewController)
        }
    }
    
    @objc
    func autpPlayVideo(cell: VideoPlayerInCollectionViewCell) {
        if self.hostViewController != nil{
            cell.stopPlayingTrailer()
            cell.playVideo(in: self.hostViewController)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoPlayerInCollectionViewCell {
            cell.stopPlayingTrailer()
        }
    }
    
    private func getSimilarShowsCell(with indexPath: IndexPath, show: Show, cellCornerRadius: CGFloat = 4) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.similarShows,
                                                      for: indexPath) as! HomeShowCollectionViewCell
        cell.show = show
        
        cell.containerCornerRadius = cellCornerRadius
        return cell
    }
}
