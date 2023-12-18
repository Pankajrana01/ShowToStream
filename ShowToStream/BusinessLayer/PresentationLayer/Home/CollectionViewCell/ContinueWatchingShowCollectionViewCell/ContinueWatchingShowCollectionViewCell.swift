//
//  ContinueWatchingShowCollectionViewCell.swift
//  ShowToStream
//
//  Created by Applify on 18/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
class ContinueWatchingShowCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var timerView: UIView!
    @IBOutlet weak var availbleForNextLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var show: Show! { didSet { showDidSet() } }
    var showViewMore = false
    lazy var refreshTimer = Timer()
    
    var animationDuration: Double = 0.0
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.posterImageView.setOpacity(to: 0)
            self.timeLabel.setOpacity(to: 0)
            self.progressView.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.posterImageView.setOpacity(to: 1)
            self.timeLabel.setOpacity(to: 1)
            self.progressView.setOpacity(to: 1)
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
        // setShimmer()
        titleLbl.text = show.title
        if show.contentThumbnail != "" {
            //   DispatchQueue.main.async { [unowned self] in
            posterImageView.setImage(with: show.contentThumbnail ?? "", placeholderImage: #imageLiteral(resourceName: "HomeLogo"))
            //                self.removeShimmer()
            //                self.showViews()
            //  }
        }
        
        if show.paymentType == "1"{
            if show.timeLeft == "" {
                timerView.isHidden = true
                availbleForNextLbl.isHidden = true
            } else {
                timerView.isHidden = false
                availbleForNextLbl.isHidden = false
                timeLabel.text = show.timeLeft
            }
        } else {
            timerView.isHidden = true
            availbleForNextLbl.isHidden = true
        }
        if show.playDuration != nil && show.totalPlayDuration != nil{
            if show.playDuration != nil || show.totalPlayDuration != nil {
                let totalDuration = Int((bindData(timer:show.playDuration ?? "0").timeIntervalSince(Date())))
                let totalPlayedDuration  = Int((bindData(timer:show.totalPlayDuration ?? "0").timeIntervalSince(Date())))
                
                print(totalDuration, totalPlayedDuration)
                
                if totalDuration != 0 {
                    let totalTime = (totalPlayedDuration * 100)/totalDuration
                    
                    print(totalTime)
                    
                    progressView.progress   = Float(totalTime) / 100.0
                }else{
                    progressView.progress   = Float(0.0)
                }
            }else{
                progressView.progress   = Float(0.0)
            }
        }
    }
   
    func bindData(timer: String) -> Date{
        let seconds = self.getTimerStartValueInSeconds(with: timer)
        let date =  Date(timeIntervalSinceNow: TimeInterval(seconds))
        return date
     }
    
    private func getTimerStartValueInSeconds(with value:String) -> Int {
        let array = value.components(separatedBy: ":")
        var hours = Int()
        var minutes = Int()
        var seconds = Int()
        if array.count == 2{
             hours = (Int(array[0]) ?? 0) * 60 * 60
             minutes = (Int(array[1]) ?? 0) * 60
             seconds = 0
        }else{
             hours = (Int(array[0]) ?? 0) * 60 * 60
             minutes = (Int(array[1]) ?? 0) * 60
             seconds = (Int(array[2]) ?? 0)
        }
        return Int(hours + minutes + seconds)
    }
}
