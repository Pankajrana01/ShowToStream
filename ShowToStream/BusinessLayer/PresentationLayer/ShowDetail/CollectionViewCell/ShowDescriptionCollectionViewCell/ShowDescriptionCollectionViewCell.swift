//
//  ShowDescriptionCollectionViewCell.swift
//  ShowToStream
//
//  Created by Applify on 21/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import SwiftyGif
import UIKit

class ShowDescriptionCollectionViewCell: UICollectionViewCell {
    var watchlistButtonAction: (() -> Void)?
    var shareButtonAction: (() -> Void)?
    var reportButtonAction: (() -> Void)?
    var applauseButtonAction: (() -> Void)?
    var standingOvationButtonAction: (() -> Void)?
    var toggleDescriptionButtonAction: (() -> Void)?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var applauseCountLabel: UILabel!
    @IBOutlet private weak var standingOvationCountLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var heartGifImageView: UIImageView!
    @IBOutlet weak var addToWatchList: UILabel!
    
    var show: Show! { didSet { showDidSet() } }
    
    var showFullDescription: Bool = false { didSet {
        descriptionLabel.numberOfLines  = showFullDescription ? 0 : 2
        arrowImageView.image            = showFullDescription ? #imageLiteral(resourceName: "Collapse") : #imageLiteral(resourceName: "Expand")
    } }
    
    private func showDidSet() {
        titleLabel.text                 = show.title
        genreLabel.text                 = show.displaybleProducerAndGenre
        descriptionLabel.attributedText = show.displaybleDescription
        applauseCountLabel.text         = "\(show.applause)"
        standingOvationCountLabel.text  = "\(show.standingOvation)"
        descriptionLabel.numberOfLines  = showFullDescription ? 0 : 2
        arrowImageView.image            = showFullDescription ? #imageLiteral(resourceName: "Collapse") : #imageLiteral(resourceName: "Expand")
        
        if show.addedToWatchlist {
            self.addToWatchList.text = WebConstants.addedtoWatchlist
            self.heartGifImageView.isHidden = false
            if let gif = try? UIImage(gifName: StringConstants.heartGif) {
                self.heartGifImageView.setGifImage(gif, loopCount: 0)
            }
        } else {
            self.addToWatchList.text = WebConstants.addtoWatchlist
            self.heartGifImageView.isHidden = true
            self.heartImageView.image = #imageLiteral(resourceName: "Heart")
        }
    }
    
    @IBAction func applauseButtonTapped(_ sender: Any?) {
        applauseButtonAction?()
    }
    
    @IBAction func standingOvationButtonTapped(_ sender: Any?) {
        standingOvationButtonAction?()
    }

    
    @IBAction func watchlistButtonTapped(_ sender: Any?) {
        watchlistButtonAction?()
        self.show.addedToWatchlist.toggle()
//        if let action = watchlistButtonAction {
//            if action() {
//                show.addedToWatchlist.toggle()
//                if show.addedToWatchlist {
//                    self.heartGifImageView.isHidden = false
//                    if let gif = try? UIImage(gifName: StringConstants.heartGif) {
//                        self.heartGifImageView.setGifImage(gif, loopCount: 1)
//                    }
//
//                } else {
//                    self.heartGifImageView.isHidden = true
//                    self.heartImageView.image = #imageLiteral(resourceName: "Heart")
//                }
//            }
//        }
    }
   

    @IBAction func shareButtonTapped(_ sender: UIButton?) {
        self.shareShow(showName: self.show.title!)
    }

    @IBAction func actionReport(_ sender: Any) {
        reportButtonAction?()
    }
    
    @IBAction func toggleDescriptionButtonTapped(_ sender: Any?) {
        toggleDescriptionButtonAction?()
    }
    //https://www.showtostream.com/explore/exp-detail?id=60796f65d198b4752c5289d0
    func shareShow(showName:String) {
        let shareText = "Check out " + "\(showName)" + " on " + "ShowtoStream" + "\n" + "https://www.showtostream.com/explore/exp-detail?id=" + "\(show._id ?? "")"
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        if let popOver = vc.popoverPresentationController {
            popOver.sourceView = self.contentView
            popOver.sourceRect = self.contentView.bounds
        }
        
        var parentController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while (parentController?.presentedViewController != nil &&
                parentController != parentController!.presentedViewController) {
            parentController = parentController!.presentedViewController
        }
        
        parentController?.present(vc, animated: true)
        
    }
}
