//
//  VideoPlayerView.swift
//  ShowToStream
//
//  Created by 1312 on 21/12/20.
//

import AVKit
import UIKit
import FaveButton

var onNextVideoButtonAction:(() -> Void)?

class VideoPlayerView: UIView, FaveButtonDelegate {

    class func instanceFromNib(with playerLayer: AVPlayerLayer, asset: AVAsset, controlsAvailable: Bool = false, show:Show) -> VideoPlayerView {
        let view = UINib(nibName: "VideoPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VideoPlayerView
        
        view.setupVideoPlayer(with: playerLayer, asset: asset, controlsAvailable: controlsAvailable, show: show)
        
        return view
    }

    @IBOutlet weak var feedbackContainerView: UIView!
    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var videoContainerView: UIView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var forwardSeekButton: UIButton!
    @IBOutlet private weak var backwardSeekButton: UIButton!
    @IBOutlet private weak var pipButton: UIButton!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var clapsButton: FaveButton!
    @IBOutlet private weak var applauseView: UIView!
    @IBOutlet private weak var standingOvationView: UIView!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var subTitleButton: UIButton!
    @IBOutlet private weak var clapButton: UIButton!
    @IBOutlet private weak var castButton: UIButton!
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet weak var videoTitileLbl: UILabel!
    @IBOutlet weak var viewNextContainerView: UIView!
    @IBOutlet weak var lastVideoTitleLbl: UILabel!
    @IBOutlet weak var applauseStackView: NSLayoutConstraint!
    
    private var _playerLayer: AVPlayerLayer!
    var playerLayer: AVPlayerLayer {
        return _playerLayer
    }

    private var _asset: AVAsset!
    var asset: AVAsset {
        return _asset
    }
    
    private var _controlsAvailable: Bool = false
    
    @IBAction func nextVideoBtnAction(_ sender: Any) {
        onNextVideoButtonAction?()
    }
    
    func setupVideoPlayer(with playerLayer: AVPlayerLayer, asset: AVAsset, controlsAvailable: Bool = false, show:Show) {
        forwardSeekButton.imageView?.contentMode = .scaleAspectFit
        backwardSeekButton.imageView?.contentMode = .scaleAspectFit
        playPauseButton.imageView?.contentMode = .scaleAspectFit

        _playerLayer        = playerLayer
        _asset              = asset
        _controlsAvailable  = controlsAvailable
        _playerLayer.frame  = videoContainerView.bounds
        videoContainerView.layer.addSublayer(_playerLayer)
        UIView.performWithoutAnimation {
            buttonContainerView.layer.opacity = controlsAvailable ? 1 : 0
        }
        
        slider.setThumbImage(#imageLiteral(resourceName: "sliderThumb"), for: .normal)
        slider.setThumbImage(#imageLiteral(resourceName: "sliderThumb"), for: .highlighted)
        slider.isContinuous = true
        
        updateFeedBackView(show: show)
        clapButton.isHidden = true
        clapsButton.delegate = self
        clapsButton.setSelected(selected: true, animated: false)
        feedbackContainerView.isHidden = true
        viewNextContainerView.isHidden = true

        castButton.tintColor = UIColor.white
        
        let routePickerView = AVRoutePickerView(frame: self.castButton.bounds)
        routePickerView.prioritizesVideoDevices = true
    
        castButton.addSubview(routePickerView)
    }
    
    func updateFeedBackView(show:Show, hideViews: Bool? = false){
        if hideViews ?? false {
            viewNextContainerView.isHidden = true
            feedbackContainerView.isHidden = true
            return
        }
        if let ids = show.sequenceContentId, let index = ids.firstIndex(where: { $0._id == show._id}), index < ((show.sequenceContentId?.count ?? 0) - 1) {
            feedbackContainerView.isHidden = true
            viewNextContainerView.isHidden = false
            
            videoTitileLbl.text = show.title
        } else {
            lastVideoTitleLbl.text = show.title
            
            viewNextContainerView.isHidden = true
            clapButton.isHidden = false
            feedbackContainerView.isHidden = false
            if show.isApplause == true, show.isStandingOvation == true {
                applauseStackView.constant = 0
            } else {
                applauseStackView.constant = 110
            }
            if show.isApplause == true{
                applauseView.isHidden = true
            } else {
                applauseView.isHidden = false
            }
            if show.isStandingOvation == true{
                standingOvationView.isHidden = true
            } else {
                standingOvationView.isHidden = false
            }
        }
    }

    var playButtonAction:(() -> Bool)?
    var fullScreenButtonAction:(() -> Void)?
    var forwardSeekButtonAction:(() -> Void)?
    var backwardSeekButtonAction:(() -> Void)?
    var settingsButtonAction:(() -> Void)?
    var castButtonAction:(() -> Void)?
    var subtitlesButtonAction:(() -> Void)?
    var clapsButtonAction:(() -> Void)?
    var audioButtonAction:(() -> Void)?
    var sliderValueChanged:((Float, UIEvent) -> Void)?
    var applauseButtonAction:(() -> Void)?
    var standingOvationButtonAction:(() -> Void)?

    var duration: Float64 {
        return CMTimeGetSeconds(_asset.duration)
    }
    var currentSeekTime: Float64 = 0 {
        didSet {
            forwardSeekButton.alpha = currentSeekTime > duration - 10 ? 0.56 : 1
            backwardSeekButton.alpha = currentSeekTime < 10 ? 0.56 : 1
            slider.value = Float(currentSeekTime / duration)
            print(slider.value)
            timeLabel.text = stringFromTimeInterval(interval: currentSeekTime)
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti: Int = Int(interval)
        let seconds: Int = ti % 60
        let minutes: Int = (ti / 60) % 60
        let hours: Int = (ti / 3600)
        var time: String? = nil
        if hours > 0 {
            time = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
        else {
            time = String(format: "%02i:%02i", minutes, seconds)
        }
        return time!
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        _playerLayer.frame = videoContainerView.bounds
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view != feedbackContainerView{
            cancelAllScheduledPerformRequest()
        }
        
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view != feedbackContainerView{
            checkAndShowHideControlsOrSchedule()
        }
    }
    
    /**
     Like on tap of settings button, a new screen is presented, and the controls are requested to be visible. But when the screen is dismissed, the controls should go away after the default timeout. so call this method.
     */
    func gotFocus() {
        renewTimerForAutoHideControls()
    }
    
    fileprivate func cancelAllScheduledPerformRequest() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }

    fileprivate func checkAndShowHideControlsOrSchedule() {
        if !_controlsAvailable {
            return
        }
        if buttonContainerView.alpha == 0 {
            self.showControls()
            self.perform(#selector(hideControls) , with: nil, afterDelay: 2.5)
        } else {
            self.hideControls()
        }
    }
    
    fileprivate func renewTimerForAutoHideControls() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(hideControls) , with: nil, afterDelay: 2.5)
    }

    private func updateForPlayingVideo() {
        UIView.performWithoutAnimation {
            playPauseButton.imageView?.contentMode = .scaleAspectFit
            playPauseButton.setImage( #imageLiteral(resourceName: "Pause"), for: .normal)
            playPauseButton.layoutIfNeeded()
        }
    }

    private func updateForPausedVideo() {
        UIView.performWithoutAnimation {
            playPauseButton.imageView?.contentMode = .scaleAspectFit
            playPauseButton.setImage(#imageLiteral(resourceName: "PlayControl"), for: .normal)
            playPauseButton.layoutIfNeeded()
        }
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if let closure = playButtonAction {
            closure() ? updateForPlayingVideo() : updateForPausedVideo()
        }
        renewTimerForAutoHideControls()
    }
    

    @IBAction func fullScreenButtonTapped(_ sender: Any?) {
        fullScreenButtonAction?()
        renewTimerForAutoHideControls()
    }

    @IBAction func forwardSeekButtonTapped(_ sender: Any?) {
        if forwardSeekButton.alpha == 1 {
            forwardSeekButtonAction?()
        }
        renewTimerForAutoHideControls()
    }
    
    @IBAction func backwardSeekButtonTapped(_ sender: Any?) {
        if backwardSeekButton.alpha == 1 {
            backwardSeekButtonAction?()
        }
        renewTimerForAutoHideControls()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any?) {
        settingsButtonAction?()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
   
    @IBAction func castButtonTapped(_ sender: Any) {
        let routePickerView = AVRoutePickerView(frame: self.castButton.bounds)
//        routePickerView.backgroundColor = UIColor.clear
        castButton.addSubview(routePickerView)
        
        
       // castButtonAction?()
       // NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @IBAction func subtitlesButtonTapped(_ sender: Any?) {
        subtitlesButtonAction?()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @IBAction func clapsButtonTapped(_ sender: Any?) {
        //clapsButtonAction?()
        applauseButtonAction?()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @IBAction func audioButton(_ sender: Any) {
        audioButtonAction?()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @IBAction func sliderValueChanged(sender: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch (touchEvent.phase) {
            case .began:
                NSObject.cancelPreviousPerformRequests(withTarget: self)
                break
            case .ended:
                renewTimerForAutoHideControls()
                break
            default:
                break
            }
        }
        print(sender.value)
        sliderValueChanged?(sender.value, event)
    }
    
    @objc
    private func hideControls(_ duration: TimeInterval = 0.2) {
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0.0
        opacity.duration = duration
        buttonContainerView.layer.add(opacity, forKey: "fade")
        buttonContainerView.layer.opacity = 0
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("HideReleatedShow"), object: nil)
    }

    @objc
    private func showControls() {
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1.0
        opacity.duration = 0.35
        buttonContainerView.layer.add(opacity, forKey: "fade")
        buttonContainerView.layer.opacity = 1
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("ShowReleatedShow"), object: nil)
    }
    
    @IBAction func applauseButtonTapped(_ sender: Any) {
//        applauseButtonAction?()
    }
    
    @IBAction func standingOvationButtonTapped(_ sender: Any) {
        standingOvationButtonAction?()
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        clapsButton?.setSelected(selected: false, animated: false)
        applauseButtonAction?()
    }
}
