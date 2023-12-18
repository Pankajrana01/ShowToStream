//
//  ShowBannerCollectionViewCell.swift
//  ShowToStream
//
//  Created by Applify on 21/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class ShowBannerCollectionViewCell: UICollectionViewCell {
    var watchNowAction: (() -> Void)?
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var timeLabel: UILabel!
    
    var similarShows: [Show] = []
    var show: Show! { didSet { showDidSet() } }
    var containerCornerRadius: CGFloat! {
        didSet {
            containerView.cornerRadius = containerCornerRadius
        }
    }
    
    func showDidSet() {
        timeLabel.isHidden = true
        timeLabel.text = show.playDuration
        posterImageView.image = #imageLiteral(resourceName: "Logo")
        posterImageView.contentMode = .scaleAspectFit
        delay(1.0){
            if self.show.contentThumbnail != "" {
                self.posterImageView.setImage(with: self.show.contentThumbnail ?? "", placeholderImage: #imageLiteral(resourceName: "HomeLogo"))
                self.posterImageView.contentMode = .scaleAspectFill
            }
        }
        
    }
    
    @IBAction func watchNowTapped(_ sender: Any?) {
        watchNowAction?()
    }
}

extension ShowBannerCollectionViewCell: VideoPlayerInCollectionViewCell {
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
    
    func playVideo(in viewController: BaseViewController) {
        if let urlAsset = show.urlAsset {
            VideoPlayerManager.shared.playVideo(in: containerView, in: viewController, for: urlAsset, show: show, similarShows: similarShows)
        }
    }

    func stopPlayingVideo() {
//        DispatchQueue.main.async {
//            if self.show.urlAsset != nil {
//                VideoPlayerManager.shared.pauseVideo(in: self.containerView)
//            }
//        }
    }
 
}
