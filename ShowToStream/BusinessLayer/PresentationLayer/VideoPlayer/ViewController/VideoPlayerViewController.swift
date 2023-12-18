//
//  VideoPlayerViewController.swift
//  ShowToStream
//
//  Created by 1312 on 21/12/20.
//

import UIKit
import AVKit

class VideoPlayerViewController: BaseViewController {
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.videoPlayer
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.videoPlayer
    }
    
    lazy var viewModel = VideoPlayerViewModel(hostViewController: self)
    @IBOutlet private weak var videoContainerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController, asset: AVAsset, show : Show, similarShows : [Show]) {
        let controller = self.getController() as! VideoPlayerViewController
        controller.show(from: viewController, asset: asset, show: show, similarShows: similarShows)
    }

    func show(from viewController: UIViewController, asset: AVAsset, show : Show, similarShows : [Show]) {
        self.viewModel.asset = asset
        self.viewModel.show = show
        self.viewModel.similarShows = similarShows
        viewController.present(self, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.collectionView = collectionView
        
        self.collectionView.isHidden = true
        
        let nc = NotificationCenter.default
        
        nc.addObserver(self, selector: #selector(hideReleatedShow), name: Notification.Name("HideReleatedShow"), object: nil)
        
        nc.addObserver(self, selector: #selector(showReleatedShow), name: Notification.Name("ShowReleatedShow"), object: nil)
        
        VideoPlayerManager.shared.playVideo(in: videoContainerView, in: self, for: self.viewModel.asset, show: self.viewModel.show, similarShows: viewModel.similarShows)
        
        if viewModel.similarShows.count == 0 {
            viewModel.getSimliarShow()
        }
        
        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        
        swipeup.direction = UISwipeGestureRecognizer.Direction.up
        
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipedown.direction = UISwipeGestureRecognizer.Direction.down
        
        self.videoContainerView.addGestureRecognizer(swipeup)
        
        self.videoContainerView.addGestureRecognizer(swipedown)
        
//        videoContainerView.transform = CGAffineTransform(scaleX: 0.65, y: 0.25)

//        UIView.animate(withDuration: 5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
//
//            self.videoContainerView.transform = .identity
//
//        }) { (completed:Bool) in
//            // Completion block
//        }

    }
    
    @objc func hideReleatedShow(){
        self.collectionView.isHidden = true
    }
    @objc func showReleatedShow(){
       // self.collectionView.isHidden = false
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                self.collectionView.isHidden = true
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
                showCollectionView()
            default:
                break
            }
        }
    }
    
    func showCollectionView(){
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.collectionView.isHidden = false
                        self.collectionView.alpha = 1.0
        }, completion: { _ in
            
        })
//        
//        UIView.animate(withDuration: 5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
//            self.collectionView.isHidden = false
//            self.collectionView.transform = .identity
//            
//            
//        }) { (completed:Bool) in
//            // Completion block
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OrientationLockUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OrientationLockUtility.lockOrientation(.portrait, andRotateTo: .portrait)

    }
    
    override func backButtonTapped(_ sender: Any?) {
        OrientationLockUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        VideoPlayerManager.shared.fullScreenController = nil
        VideoPlayerManager.shared.fullScreenVideoPlayerView = nil
        //VideoPlayerManager.shared.startPipController()
        super.backButtonTapped(sender)
    }
    
}
