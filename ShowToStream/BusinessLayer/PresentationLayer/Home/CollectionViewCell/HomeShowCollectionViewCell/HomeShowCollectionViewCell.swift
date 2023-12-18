//
//  HomeShowCollectionViewCell.swift
//  ShowToStream
//
//  Created by Applify on 17/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class HomeShowCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var tagContainerView: GradientView!

    var show: Show! { didSet { showDidSet() } }
    var showtag = Bool()
    var containerCornerRadius: CGFloat! {
        didSet {
            containerView.cornerRadius = containerCornerRadius
        }
    }
    
    var animationDuration: Double = 0.0
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.posterImageView.setOpacity(to: 0)
            self.tagLabel.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.posterImageView.setOpacity(to: 1)
            self.tagLabel.setOpacity(to: 1)
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
    
    func showDidSet() {
        //setShimmer()
        
        if let tag = show.tag {
            if tag.isEmpty{
                tagContainerView.isHidden = true
            }else{
                tagLabel.text = tag
                tagContainerView.isHidden = false
            }
        } else {
            tagContainerView.isHidden = true
        }
        
        if show.contentThumbnail != "" {
          //  DispatchQueue.main.async { [unowned self] in
                posterImageView.setImage(with: show.contentThumbnail ?? "", placeholderImage: #imageLiteral(resourceName: "HomeLogo"))
//                self.removeShimmer()
//                self.showViews()
           // }
        }
        
        
        DispatchQueue.main.async {
            self.tagContainerView.updateGradient()
            self.tagContainerView.roundCorners(corners: [.topRight, .bottomRight], radius: 13)
        }
    }
}
