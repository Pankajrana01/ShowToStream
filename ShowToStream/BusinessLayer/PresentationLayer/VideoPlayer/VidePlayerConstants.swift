//
//  VidePlayerConstants.swift
//  ShowToStream
//
//  Created by 1312 on 21/12/20.
//

import UIKit

extension UIStoryboard {
    class var videoPlayer: UIStoryboard {
        return UIStoryboard(name: "VideoPlayer", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let videoPlayer              = "VideoPlayerViewController"
    static let changeStreamQuality      = "ChangeStreamQualityViewController"
    static let changeSubtitle           = "ChangeSubtitleViewController"
}

extension TableViewCellIdentifier {
    static let streamQuality            = "streamQuality"
}

extension CollectionViewCellIdentifier {
    static let streamSubtitle           = "streamSubtitle"
}

@objc
protocol TrailerPlayerInCollectionViewCell {
    func playTrailer(in viewController: BaseViewController)
    func stopPlayingTrailer()
}

@objc
protocol VideoPlayerInCollectionViewCell: TrailerPlayerInCollectionViewCell {
    func playVideo(in viewController: BaseViewController)
    func stopPlayingVideo()
}


extension StringConstants{
    static let subtitle              = "Subtitles"
    static let audio                 = "Audio"
}
