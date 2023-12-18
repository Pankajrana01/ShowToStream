//
//  VideoPlayerManager.swift
//  ShowToStream
//
//  Created by 1312 on 21/12/20.
//

import UIKit
import AVKit
import Alamofire

extension AVPlayer {
    var isPlaying: Bool {
        return self.timeControlStatus != .paused
    }
}

extension AVAsset {
    var videoSize: CGSize {
        let tracks = self.tracks(withMediaType: AVMediaType.video)
        if (tracks.count > 0){
            let videoTrack = tracks[0]
            let size = videoTrack.naturalSize
            let txf = videoTrack.preferredTransform
            let realVidSize = size.applying(txf)
            print(videoTrack)
            print(txf)
            print(size)
            print(realVidSize)
            return realVidSize
        }
        return CGSize(width: 0, height: 0)
    }
}

extension UIView {
    fileprivate var getVideoPlayerView: VideoPlayerView? {
        let view = self.subviews.first(where: { $0 is VideoPlayerView })
        return view as? VideoPlayerView
    }
}

extension UIWindow {
    fileprivate class var topViewController: UIViewController? {
        return topViewController()
    }
    
    fileprivate class func topViewController(controller: UIViewController? = KAPPDELEGATE.window?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        //        if let slideMenuVC = controller as? SlideMenuController {
        //            return topViewController(controller: slideMenuVC.mainViewController)
        //        }
        return controller
    }
}

class VideoPlayerManager: NSObject {
    lazy var HLS : HLSParser = {
        return HLSParser()
    }()
    
    var show : Show!
    static let shared = VideoPlayerManager()
    var similarShows: [Show] = []
    var canAutoPlayTraier: Bool {
        return !isPlayingActualVideo && !isPlayingVideoInMiniPlayer
    }
    var shouldPlayVideo: Bool = false
    var isPlayingActualVideo: Bool = false
    var currentVideoPlayerView: VideoPlayerView?
    var currentController: BaseViewController?
    var fullScreenVideoPlayerView: VideoPlayerView?
    var fullScreenController: BaseViewController?
    
    var isPlayingVideoInMiniPlayer: Bool = false
    
    var pipViewControllerReference: UIViewController?
    
    private var pipController : STSPictureInPictureController?
    private var pictureInPictureObservations = [NSKeyValueObservation]()
    private let audioRenderer = AVSampleBufferAudioRenderer()
    private let renderSynchronizer = AVSampleBufferRenderSynchronizer()
    
    var mediaCharacteristicSubtitle = [String]()
    var mediaCharacteristicAudible = [String]()
    var mediaPlaylists = [String]()
    var mediaPlaylistsBandwidth = [String]()
    var masterPlaylists : MasterPlaylist!
    var selectedIndex = 0
    let player: AVPlayer = {
        let player = AVPlayer()
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { progressTime in
            
            if let item = player.currentItem,
                let currentVideoPlayerView = VideoPlayerManager.shared.currentVideoPlayerView {
                let duration = item.duration
                
                let durationSeconds = CMTimeGetSeconds(duration)
                let seconds = CMTimeGetSeconds(progressTime)
                let progress = Float(seconds/durationSeconds)
                
                currentVideoPlayerView.currentSeekTime = CMTimeGetSeconds(item.currentTime())
            }
            
            if let item = player.currentItem,
                let currentVideoPlayerView = VideoPlayerManager.shared.fullScreenVideoPlayerView {
                let duration = item.duration
                
                let durationSeconds = CMTimeGetSeconds(duration)
                let seconds = CMTimeGetSeconds(progressTime)
                let progress = Float(seconds/durationSeconds)

                currentVideoPlayerView.currentSeekTime = CMTimeGetSeconds(item.currentTime())
            }
           
        }
        
        return player
    }()

    func setBitRate(_ definition: String) {
        var maxBitRate: Double = 0
        switch definition {
        case "240":
            maxBitRate = 258157
        case "360":
            maxBitRate = 1500000
        case "480":
            maxBitRate = 2000000
        case "720":
            maxBitRate = 4000000
        case "1080 (HD)":
            maxBitRate = 6000000
        case "2k":
            maxBitRate = 16000000
        case "4k":
            maxBitRate = 45000000
        case "Auto":
            maxBitRate = 0
        default:
            maxBitRate = 0
        }
        player.currentItem?.preferredPeakBitRate = maxBitRate
        player.replaceCurrentItem(with: player.currentItem)
        print("Playing in Bit Rate \(String(describing:player.currentItem?.preferredPeakBitRate))")
    }
    private override init() {
        super.init()
    }
    
    func initialize() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch  {
            print("Audio session failed")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForeground), name: .appEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeInactive), name: .appBecomeInactive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
       // NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlay(_:)), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)

    }
}

extension VideoPlayerManager {
    
    @discardableResult
    fileprivate func addPlayer(to view: UIView, for asset: AVAsset, needControls: Bool = false, contentsGravity: CALayerContentsGravity = .resizeAspect, videoGravity: AVLayerVideoGravity = .resizeAspect) -> VideoPlayerView {
        
        if let alreadyAddedView = view.getVideoPlayerView {
            alreadyAddedView.removeFromSuperview()
        }
        setupVideoPlayer(with: asset)
        
        let videoPlayerView = getNewVideoPlayerView(with: asset, needControls: needControls, contentsGravity: contentsGravity, videoGravity: videoGravity)
        
        let topConstraint = NSLayoutConstraint(item: videoPlayerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: videoPlayerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: videoPlayerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: videoPlayerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        view.addSubview(videoPlayerView)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        videoPlayerView.layoutSubviews()
        return videoPlayerView
    }
}

extension VideoPlayerManager {
    func autoPlayTrailer(in view: UIView, in viewController: BaseViewController, for asset: AVAsset, show: Show) {
        if canAutoPlayTraier {
            self.show = show
            let videoPlayerView = addPlayer(to: view, for: asset, needControls: false, contentsGravity: .resizeAspect, videoGravity: .resizeAspect)
            currentVideoPlayerView = videoPlayerView
            currentController = viewController
            view.bringSubviewToFront(videoPlayerView)
            view.translatesAutoresizingMaskIntoConstraints = false
            player.playImmediately(atRate: 1.0)
        }
    }
    
    func autoPauseTrailer(in view: UIView) {
        if canAutoPlayTraier,
           let videoPlayerView = view.getVideoPlayerView,
           currentVideoPlayerView == videoPlayerView,
           isPlayingAsset(asset: videoPlayerView.asset) {
            currentVideoPlayerView = nil
            currentController = nil
            view.sendSubviewToBack(videoPlayerView)
            player.pause()
        }
    }

    func autoPauseTrailer(in viewController: BaseViewController) {
        if currentController == viewController,
           let superView = currentVideoPlayerView?.superview {
            self.autoPauseTrailer(in: superView)
        }
    }
    
    func playVideo(in view: UIView, in viewController: BaseViewController, for asset: AVAsset, show: Show, similarShows : [Show]) {
        print("playVideo in view called")
        self.show = show
        self.similarShows = similarShows
        
        // pause any trailer that is already being played.
        if let currentController = currentController {
            autoPauseTrailer(in: currentController)
        }
        
        // pause any actual video that is already being played.
        if let currentController = currentController {
            if asset != player.currentItem?.asset {
                shouldPlayVideo = true

                pauseVideo(in: currentController)
            } else if currentController == viewController {
                return
            }
        } else {
            shouldPlayVideo = true
        }
        
        if let currentController = fullScreenController {
            if asset != player.currentItem?.asset {
                shouldPlayVideo = true
                pauseVideo(in: currentController)
            }
        } else {
            shouldPlayVideo = true
        }
        // --------------------------------------------------

        let videoPlayerView = addPlayer(to: view, for: asset, needControls: true)
        view.bringSubviewToFront(videoPlayerView)

        isPlayingActualVideo = true
        
        if viewController is VideoPlayerViewController {
            fullScreenVideoPlayerView = videoPlayerView
            fullScreenController = viewController
        } else {
            currentVideoPlayerView = videoPlayerView
            currentController = viewController
        }

        if shouldPlayVideo {
            player.play()
            setupPipMiniPlayer()
        }
        videoPlayerView.gotFocus()
    }

    func pauseVideo(in view: UIView) {
        print("pauseVideo in view called")
        if let videoPlayerView = view.getVideoPlayerView,
           currentVideoPlayerView == videoPlayerView {
            isPlayingActualVideo = false
            currentVideoPlayerView = nil
            currentController = nil
            view.sendSubviewToBack(videoPlayerView)
            player.pause()
        }
    }

    func pauseVideo(in viewController: BaseViewController) {
        print("pauseVideo in view contorller clalled")
        if currentController == viewController,
           let superView = currentVideoPlayerView?.superview {
            self.pauseVideo(in: superView)
        }
    }
    
}

extension VideoPlayerManager { // helper methods
    fileprivate func getNewPlayerLayer(with player: AVPlayer, contentsGravity: CALayerContentsGravity = .resizeAspect, videoGravity: AVLayerVideoGravity = .resizeAspect) -> AVPlayerLayer {
        var _playerLayer = AVPlayerLayer(player: player)
        _playerLayer = AVPlayerLayer(player: player)
        _playerLayer.contentsGravity = contentsGravity
        _playerLayer.videoGravity = videoGravity
        return _playerLayer
    }

    fileprivate func setupVideoPlayer(with asset: AVAsset) {
        if asset != player.currentItem?.asset {
            let item = AVPlayerItem(asset: asset)
            player.replaceCurrentItem(with: item)
        } else {
            let item = AVPlayerItem(asset: asset)
            player.replaceCurrentItem(with: item)
        }
    }

    fileprivate func getNewVideoPlayerView(with asset: AVAsset, needControls: Bool = false, contentsGravity: CALayerContentsGravity = .resizeAspect, videoGravity: AVLayerVideoGravity = .resizeAspect) -> VideoPlayerView {
        
        let videoPlayerView = VideoPlayerView.instanceFromNib(with: getNewPlayerLayer(with: player, contentsGravity: contentsGravity, videoGravity: videoGravity), asset: asset, controlsAvailable: needControls, show: show)
        
        self.getAvailableMediaCharacteristicsWithMediaSelectionOptions(with: asset)
        self.getStreamPlaylist(with: self.show.streamUrl)
        
        videoPlayerView.playButtonAction = {
            if NetworkReachabilityManager()?.isReachable == false {
                showMessage(with: GenericErrorMessages.noInternet, theme: .error)
            }else{
                self.player.isPlaying ? self.player.pause() : self.player.play()
               
            }
            return self.player.isPlaying
        }
        
        videoPlayerView.fullScreenButtonAction = {
            DispatchQueue.main.async {
                videoPlayerView.setNeedsDisplay()
                self.stopPipController()
            }
            if let currentController = self.currentController {
                if let fullScreenController = self.fullScreenController {
                    fullScreenController.backButtonTapped(nil)
                    self.fullScreenController = nil
                    self.fullScreenVideoPlayerView = nil
                } else {
                    VideoPlayerViewController.show(from: currentController, asset: videoPlayerView.asset, show: self.show, similarShows: self.similarShows)
                    DispatchQueue.main.async {
                        videoPlayerView.setNeedsDisplay()
                        self.stopPipController()
                    }
                }
            }
           
        }
        videoPlayerView.forwardSeekButtonAction = {
            let item = self.player.currentItem!
            let currentDuration : CMTime = item.currentTime()
            let newCurrentTime: TimeInterval = CMTimeGetSeconds(currentDuration) + 10
            let seekToTime: CMTime = CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 600)
            self.player.seek(to: seekToTime)
        }
        videoPlayerView.backwardSeekButtonAction = {
            let item = self.player.currentItem!
            let currentDuration : CMTime = item.currentTime()
            let newCurrentTime: TimeInterval = CMTimeGetSeconds(currentDuration) - 10
            let seekToTime: CMTime = CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 600)
            self.player.seek(to: seekToTime)
            DispatchQueue.main.async {
                videoPlayerView.setNeedsDisplay()
            }
        }

        videoPlayerView.settingsButtonAction = {
            if let currentController = self.currentController {
                if let fullScreenController = self.fullScreenController {
                    ChangeStreamQualityViewController.show(over: fullScreenController, videoQuality: self.mediaPlaylists, selectedIndex: self.selectedIndex) { index, quality  in
                        videoPlayerView.gotFocus()
                       // self.setBitRate(quality)
                        self.selectedIndex = index
                        if index == 0 {
                            self.player.currentItem?.preferredPeakBitRate = Double(0)
                        }else{
                            self.player.currentItem?.preferredPeakBitRate = Double(self.mediaPlaylistsBandwidth[index-1]) ?? 0
                        }
                       // self.player.replaceCurrentItem(with: self.player.currentItem)
                    }
                }else{
                    ChangeStreamQualityViewController.show(over: currentController, videoQuality: self.mediaPlaylists, selectedIndex: self.selectedIndex) { index, quality  in
                        videoPlayerView.gotFocus()
                       // self.setBitRate(quality)
                        self.selectedIndex = index
                        if index == 0 {
                            self.player.currentItem?.preferredPeakBitRate = Double(0)
                        }else{
                            self.player.currentItem?.preferredPeakBitRate = Double(self.mediaPlaylistsBandwidth[index-1]) ?? 0
                        }
                    }
                }
            } else {
                videoPlayerView.gotFocus()
            }
        }
        videoPlayerView.castButtonAction = {
            self.googleCashButtonTapped()
            videoPlayerView.gotFocus()
        }
        videoPlayerView.subtitlesButtonAction = {
            if let currentController = self.currentController {
                if let fullScreenController = self.fullScreenController {
                    ChangeSubtitleViewController.show(over: fullScreenController, subtitles: self.mediaCharacteristicSubtitle, selectedIndex: self.selectedIndex, isComeFrom: StringConstants.subtitle) { index in
                        self.selectedIndex = index
                        self.mediaSelectionGroup(with: asset, index: index)
                        videoPlayerView.gotFocus()
                    }
                    
                }else{
                    ChangeSubtitleViewController.show(over: currentController, subtitles: self.mediaCharacteristicSubtitle, selectedIndex: self.selectedIndex, isComeFrom: StringConstants.subtitle) { index in
                        self.selectedIndex = index
                        self.mediaSelectionGroup(with: asset, index: index)
                        videoPlayerView.gotFocus()
                    }
                }
            } else {
                videoPlayerView.gotFocus()
            }
        }
        
        videoPlayerView.clapsButtonAction = {
            videoPlayerView.gotFocus()
        }
        
        videoPlayerView.audioButtonAction = {
            if let currentController = self.currentController {
                if let fullScreenController = self.fullScreenController {
                    ChangeSubtitleViewController.show(over: fullScreenController, subtitles: self.mediaCharacteristicAudible, selectedIndex: self.selectedIndex, isComeFrom: StringConstants.audio) { index in
                        self.selectedIndex = index
                        self.audioSelectionGroup(with: asset, index: index)
                        videoPlayerView.gotFocus()
                    }
                    
                }else{
                    ChangeSubtitleViewController.show(over: currentController, subtitles: self.mediaCharacteristicAudible, selectedIndex: self.selectedIndex, isComeFrom: StringConstants.audio) { index in
                        self.selectedIndex = index
                        self.audioSelectionGroup(with: asset, index: index)
                        videoPlayerView.gotFocus()
                    }
                }
            } else {
                videoPlayerView.gotFocus()
            }
        }

        videoPlayerView.sliderValueChanged = { value, event in
            let item = self.player.currentItem!
            let duration : CMTime = item.duration
            
            let newCurrentTime: Float64 = CMTimeGetSeconds(duration) * Double(value)
            if let touchEvent = event.allTouches?.first {
                switch (touchEvent.phase) {
                case .began:
                    // on slider touch begin
                    self.player.pause()
                    break
                case .moved:
                    // on slider movement
                    let seekToTime: CMTime = CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 600)
                    self.player.seek(to: seekToTime, completionHandler: { (completedSeek) in
                        videoPlayerView.setNeedsDisplay()
                    })
                    
                    break
                case .ended:
                    // on slider touch end (finger lift)
                    
                    self.player.play()
                    break
                default:
                    break
                }
            }
        }
        
        videoPlayerView.applauseButtonAction = {
            self.addApplause()
        }
        
        videoPlayerView.standingOvationButtonAction = {
            self.addStandingOvation()
        }
        return videoPlayerView
    }
   
    func addApplause(){
        var params = [String:Any]()
        params[WebConstants.contentId] = self.show._id!
        params[WebConstants.clapOrNot] = true
        if KUSERMODEL.isLoggedIn() {
            params[WebConstants.profileId] = KUSERMODEL.selectedProfile._id!
        }
        processDataForAddApplause(params: params)
    }
    func addStandingOvation(){
        var params = [String:Any]()
        params[WebConstants.contentId] = self.show._id!
        if KUSERMODEL.isLoggedIn() {
            params[WebConstants.profileId] = KUSERMODEL.selectedProfile._id!
        }
        params[WebConstants.ovationOrNot] = true
        processDataForAddStandingOvation(params: params)
    }
    
    func googleCashButtonTapped(){
        player.allowsExternalPlayback = true
        print("cast start .. ")
        
        let routePickerView = AVRoutePickerView(frame: (currentController?.view.bounds)!)
        routePickerView.backgroundColor = UIColor.clear
        currentController?.view.addSubview(routePickerView)
    }
    
    func getStreamPlaylist(with stremaUrl:String){
        self.HLS.parseStreamTags(link: stremaUrl) { (response ,data) in
            print(response)
            self.mediaPlaylists = [String]()
            self.mediaPlaylists.append("Auto")

            DispatchQueue.main.async {
                for link in response {
                    if let index = link as? [String:Any] {
                        print(index)
                        if let str = index["RESOLUTION"] as? String {
                            print(str)
                            let quality = "\(index["RESOLUTION"] as? String ?? "")p"
                            self.mediaPlaylists.append(quality)
                            let bandwidth = "\(index["BANDWIDTH"] as? String ?? "")"
                            self.mediaPlaylistsBandwidth.append(bandwidth)
                        } else {
                            print(index["RESOLUTION"] as? NSString ?? "")
                            let quality = "\(index["RESOLUTION"] as? NSString ?? "")p"
                            self.mediaPlaylists.append(quality)
                            let bandwidth = "\(index["BANDWIDTH"] as? NSString ?? "")"
                            self.mediaPlaylistsBandwidth.append(bandwidth)
                        }
                    }
                }
                print(self.mediaPlaylists)
            }
        } failedBlock: { (error) in
            print(error as Any)
        }
        
        
//                let builder = ManifestBuilder()
//                if let url = NSURL(string: stremaUrl) {
//                    let manifest = builder.parse(url as URL)
//                    print(manifest.playlists)
//
//                    masterPlaylists = builder.parseMasterPlaylistFromURL(url as URL)
//                    print(masterPlaylists.playlists.count)
//                    self.mediaPlaylists = [String]()
//
//                    self.mediaPlaylists.append("Auto")
//                    for media in masterPlaylists.playlists{
//                        print(media.bandwidth)
//                        let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: Int64(media.programId), countStyle: .file)
//                        print("File Size: \(fileSizeWithUnit)")
//                        let quality = "\(media.bandwidth), " +  "\(fileSizeWithUnit)"
//                        self.mediaPlaylists.append(quality)
//                    }
//
//                    print(self.mediaPlaylists)
//
//                }
    }
    
    func getAvailableMediaCharacteristicsWithMediaSelectionOptions(with asset: AVAsset){
        for characteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
            print("\(characteristic)")
            print("\(characteristic.rawValue)")
            
            if characteristic.rawValue == "AVMediaCharacteristicAudible"{
                // Retrieve the AVMediaSelectionGroup for the specified characteristic.
                if let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                    // Print its options.
                    self.mediaCharacteristicAudible = [String]()
                    for option in group.options {
                        print(" Audio Option: \(option.displayName)")
                        print("quality1 : \(option.availableMetadataFormats)")
                        print("quality2 : \(option.mediaSubTypes)")
                        
                        
                        self.mediaCharacteristicAudible.append(option.displayName)
                    }
                    print("==----==> \(self.mediaCharacteristicAudible)")
                }
            }
            else{
                // Retrieve the AVMediaSelectionGroup for the specified characteristic.
                if let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                    // Print its options.
                    self.mediaCharacteristicSubtitle = [String]()
                    for option in group.options {
                        print(" Media Option: \(option.displayName)")
                        self.mediaCharacteristicSubtitle.append(option.displayName)
                    }
                    self.mediaCharacteristicSubtitle.insert("Off", at: 0)
                    self.mediaCharacteristicSubtitle.insert("Auto", at: 1)
                    print(self.mediaCharacteristicSubtitle)
                }
            }
        }
    }
    
    func mediaSelectionGroup(with asset: AVAsset, index: Int){
        if let group = asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible) {
            if index == 0 {
                self.player.currentItem?.select(nil, in: group)
            } else if index == 1 {
                self.player.currentItem?.selectMediaOptionAutomatically(in: group)
            } else {
                let locale = Locale(identifier: self.mediaCharacteristicSubtitle[index])
                let options =
                    AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
                print(options)
                // Select subtitle option
                if let option = options.first {
                    print(option)
                    self.player.currentItem!.select(option, in: group)
                }
            }
        }
    }
    func audioSelectionGroup(with asset: AVAsset, index: Int){
        if let group = asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible) {
            let locale = Locale(identifier: self.mediaCharacteristicAudible[index])
            let options =
                AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
            print(options)
            // Select subtitle option
            if let option = options.first {
                print(option)
                self.player.currentItem!.select(option, in: group)
            }
        }
    }
}

extension VideoPlayerManager {
    @objc
    fileprivate func playerDidFinishPlaying() {
        if let videoPlayerView = currentVideoPlayerView {
//            UIView.animate(withDuration: 1) {
//            } completion: { _ in
                if self.isPlayingActualVideo{
//                    if self.show.isApplause == true && self.show.isStandingOvation == true{
//                        videoPlayerView.superview?.sendSubviewToBack(videoPlayerView)
//                        videoPlayerView.alpha = 1
//                    }else{
                        
                        videoPlayerView.updateFeedBackView(show: self.show)
//                    }
                }else{
                    videoPlayerView.superview?.sendSubviewToBack(videoPlayerView)
                    videoPlayerView.alpha = 1
                }
                
//            }
        }
        
        if let videoPlayerView = fullScreenVideoPlayerView {
//            UIView.animate(withDuration: 1) {
//            } completion: { _ in
                if self.isPlayingActualVideo{
                    if self.show.isApplause == true && self.show.isStandingOvation == true{
                        videoPlayerView.superview?.sendSubviewToBack(videoPlayerView)
                        videoPlayerView.alpha = 1
                    }else{
                        videoPlayerView.updateFeedBackView(show: self.show)
                    }
                }else{
                    videoPlayerView.superview?.sendSubviewToBack(videoPlayerView)
                    videoPlayerView.alpha = 1
                }
            }
//        }
        isPlayingActualVideo = false
        isPlayingVideoInMiniPlayer = false
    }
    
    @objc
    func appBecomeInactive() {
    }

    @objc
    func appEnterForeground() {
        
    }
    
//    @objc func playerItemFailedToPlay(_ notification: Notification) {
//       // let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
//        showMessage(with: GenericErrorMessages.noInternet, theme: .error)
//
//    }
}

extension VideoPlayerManager {
    func isPlayingAsset(asset: AVAsset) -> Bool {
        return player.currentItem?.asset == asset
    }
}

extension VideoPlayerManager {

    fileprivate func setupPipMiniPlayer() {
        if let view = currentVideoPlayerView {

            // - Check if Picture in Picture mode is supported on user's device
            //Picture in Picture is only available on iPads with >iOS 9
            guard AVPictureInPictureController.isPictureInPictureSupported() else {
                print("Picture in Picture mode is not supported")
                return
            }
            // - Initialize an instance of AVPictureInPictureController with the AVPlayerLayer instance
            // so that the video content displayed using AVPlayerLayer can be presented in PIP mode
            pipController = STSPictureInPictureController(playerLayer: view.playerLayer)!
            
            //Assign self as a delegate to receive PIP state callbacks
            pipController!.delegate = self
            
            // - check whether PIP is possible at the current point in time
            // If PIP is not possible, we should not go ahead with the playback
            if pipController!.isPictureInPicturePossible {
                // - Video can be played in PIP mode.              
                pictureInPictureObservations.append(pipController!.observe(\.isPictureInPictureActive, options: [.initial, .new]) { [weak self] pictureInPictureController, change in
                    guard self != nil else { return }
                })
                
                pictureInPictureObservations.append(pipController!.observe(\.isPictureInPicturePossible, options: [.initial, .new]) { [weak self] pictureInPictureController, change in
                    guard self != nil else { return }
                })
                
            } else {
                // - isPictureInPicturePossible is a KVO enabled property
                //observing here for this property so that our class will be
                //notified when the PIP mode playback is actually possible.
                pipController!.addObserver(pipController!, forKeyPath: "isPictureInPicturePossible", options: [.new], context: nil)
            }
            
        }
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard keyPath == "isPictureInPicturePossible" else {
//            return
//        }
//
//        //#9 read the KVO notification for the property isPictureInPicturePossible
//        if let pipController = object as? AVPictureInPictureController {
//            if pipController.isPictureInPicturePossible {
//                //Video can be played in PIP mode.
//                pipController.startPictureInPicture()
//            }
//        }
//
//    }
    
    func startPipController(){
        pipController?.startPictureInPicture()
        isPlayingVideoInMiniPlayer = true
    }
    
    func stopPipController(){
        if pipController != nil{
            pipController!.stopPictureInPicture()
            isPlayingVideoInMiniPlayer = false
        }
    }
    
    func checkStateOfVideoPlayer(in viewController: BaseViewController){
        if shouldPlayVideo {
            let time = currentVideoPlayerView?.currentSeekTime
            if time != 0{
                self.autoPauseTrailer(in: viewController)
            }else{
                self.pauseVideo(in: viewController)
                self.autoPauseTrailer(in: viewController)
            }
        } else {
            self.autoPauseTrailer(in: viewController)
            self.pauseVideo(in: viewController)
        }
    }
    
    func stopPlayingPipViewWhenLoggedOut(in viewController: BaseViewController){
        self.currentController = nil
        self.stopPipController()
        self.autoPauseTrailer(in: viewController)
        self.pauseVideo(in: viewController)
    }
}

extension VideoPlayerManager : AVPictureInPictureControllerDelegate {
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        //Update video controls of main player to reflect the current state of the video playback.
        //You may want to update the video scrubber position.
        
//        print("it should be show detail contorller: \(currentController)")
        
//        let nc = NotificationCenter.default
//        nc.post(name: Notification.Name.pipListner, object: show)
        
        if let currentController = currentController,
           let topController = UIApplication.topViewController() {
            if topController is ShowDetailViewController {
                return
            }
            if let showDetail = currentController as? ShowDetailViewController {
                showDetail.show(from: topController, show: show, isCome: "pip", universal_showId: "")
            } else {
                currentController.show(from: topController)
            }
            pictureInPictureController.stopPictureInPicture()
        }
        
        completionHandler(true)
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP will start event       
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP did start event
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        //Handle PIP failed to start event
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP will stop event
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        //Handle PIP did start event
        // commented by Piyush. Not sure why its called here! Not sure if this call is still required after changes made by me!
//        self.pauseVideo(in: currentController!)
        
//        shouldPlayVideo = false
//        checkStateOfVideoPlayer(in: currentController!)
        isPlayingActualVideo = false
        isPlayingVideoInMiniPlayer = false
    }
}

extension VideoPlayerManager {
    
    //MARK: Api for add applause ...
    func processDataForAddApplause(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.addOrRemoveClap,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                               if !BaseViewModel.hasErrorIn(response) {
                                _ = response![APIConstants.data] as! [String:Any]
                                   
                                let nc = NotificationCenter.default
                                nc.post(name: Notification.Name.reloadShow, object: nil)
                                }
                                hideLoader()
        }
    }
    
    //MARK: Api for add standing ovation ...
    func processDataForAddStandingOvation(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.addOrRemoveOvation,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                               if !BaseViewModel.hasErrorIn(response) {
                                _ = response![APIConstants.data] as! [String:Any]
                                let nc = NotificationCenter.default
                                nc.post(name: Notification.Name.reloadShow, object: nil)
                                }
                                hideLoader()
        }
    }
}


extension UINavigationController {
    var previousViewController: UIViewController? { viewControllers.last { $0 != topViewController } }
}
