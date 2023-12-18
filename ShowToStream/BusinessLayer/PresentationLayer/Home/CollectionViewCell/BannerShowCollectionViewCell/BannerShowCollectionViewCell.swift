//
//  BannerShowCollectionViewCell.swift
//  ShowToStream
//
//  Created by Applify on 18/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import SwiftyGif
import UIKit

class BannerShowCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    
    var animationDuration: Double = 0.0
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.posterImageView.setOpacity(to: 0)
            self.showTitleLabel.setOpacity(to: 0)
            self.genreLabel.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.posterImageView.setOpacity(to: 1)
            self.showTitleLabel.setOpacity(to: 1)
            self.genreLabel.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            self.shimmer.removeLayerIfExists(self)
            self.shimmer = ShimmerLayer(for: self.posterImageView, cornerRadius: 12)
            self.layer.addSublayer(self.shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    var heartButtonAction: (() -> Bool)?
    var infoButtonAction: (() -> Void)?
    var playButtonAction: (() -> Void)?
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var heartGifImageView: UIImageView!

    var show: Show! { didSet { showDidSet() } }
   
    private func showDidSet() {
        //posterImageView.image = show.image
       // setShimmer()
        
        if show.contentThumbnail != "" {
           // DispatchQueue.main.async { [unowned self] in
                posterImageView.setImage(with: show.contentThumbnail ?? "", placeholderImage: #imageLiteral(resourceName: "HomeLogo"))
//                self.removeShimmer()
//                self.showViews()
          //  }
           
        }
        showTitleLabel.text = show.title
//        genreLabel.text = show.displaybleGenreAndCategories
        genreLabel.text = show.displaybleProducerAndGenre
        
        if show.addedToWatchlist {
            self.heartGifImageView.isHidden = false
            if let gif = try? UIImage(gifName: StringConstants.heartGif) {
                self.heartGifImageView.setGifImage(gif, loopCount: 0)
            }
        } else {
            self.heartGifImageView.isHidden = true
            self.heartImageView.image = #imageLiteral(resourceName: "Heart")
        }

    }
        
    
    @IBAction func heartButtonTapped(_ sender: Any?) {
        if let action = heartButtonAction{
            if action(){
                show.addedToWatchlist.toggle()
                if show.addedToWatchlist {
                    self.heartGifImageView.isHidden = false
                    if let gif = try? UIImage(gifName: StringConstants.heartGif) {
                        self.heartGifImageView.setGifImage(gif, loopCount: 1)
                    }
                } else {
                    self.heartGifImageView.isHidden = true
                    self.heartImageView.image = #imageLiteral(resourceName: "Heart")
                }
            }
        }
    }

    @IBAction func infoButtonTapped(_ sender: Any?) {
        infoButtonAction?()
    }
    
    @IBAction func playButtonTapped(_ sender: Any?) {
        playButtonAction?()
    }
}

extension BannerShowCollectionViewCell: TrailerPlayerInCollectionViewCell {
    func playTrailer(in viewController: BaseViewController) {
        if let trailerAsset = show.trailerAsset {
            VideoPlayerManager.shared.autoPlayTrailer(in: containerView, in: viewController, for: trailerAsset, show: show)
        }
    }

    func stopPlayingTrailer() {
        if show.trailerAsset != nil {
            VideoPlayerManager.shared.autoPauseTrailer(in: containerView)
        }
    }
}

