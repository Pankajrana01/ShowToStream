//
//  ShowDetailViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class ShowDetailViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.showDetail
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.showDetail
    }

    lazy var viewModel = ShowDetailViewModel(hostViewController: self)
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var buToOwnView: GradientView!
    @IBOutlet private weak var payPerView: GradientView!
    @IBOutlet private weak var buyOwnpriceLabel: UILabel!
    
    @IBOutlet weak var buyToOwnBottomConstraints: NSLayoutConstraint!
    
    class func getController(with isCome :String, show: Show, universal_showId:String) -> BaseViewController {
        let controller = self.getController() as! ShowDetailViewController
        controller.viewModel.isCome = isCome
        controller.viewModel.show = show
        controller.viewModel.universal_showId = universal_showId
        return controller
    }
    
    
    class func show(from viewController: UIViewController, forcePresent: Bool = true, autoEmbedInNavigationControllerIfPresent: Bool = true, show: Show, isCome :String, universal_showId:String) {
        (self.getController() as! ShowDetailViewController).show(from: viewController, forcePresent: forcePresent, autoEmbedInNavigationControllerIfPresent: autoEmbedInNavigationControllerIfPresent, show: show, isCome:isCome, universal_showId:universal_showId)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = true, autoEmbedInNavigationControllerIfPresent: Bool = true, show: Show, isCome :String, universal_showId:String) {
        self.viewModel.show = show
        self.viewModel.isCome = isCome
        self.viewModel.universal_showId = universal_showId
        if forcePresent, autoEmbedInNavigationControllerIfPresent {
            let navigationVC = UINavigationController(rootViewController: self)
            navigationVC.isNavigationBarHidden = true
            navigationVC.modalPresentationStyle = .fullScreen
            viewController.present(navigationVC, animated: true, completion: nil)
        } else {
            self.show(from: viewController, forcePresent: forcePresent)
        }
    }
    var stopCaptureView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomView.isHidden = true
        viewModel.collectionView = collectionView
        viewModel.bottomView = bottomView
        viewModel.payPerView = payPerView
        viewModel.buToOwnView = buToOwnView
        viewModel.buyToOwnBottomConstraints = buyToOwnBottomConstraints
        //self.view.makeSecure()
        currencyConversion()
      //  stopCaptureView.makeSecure()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(reloadShow), name: Notification.Name.reloadShow, object: nil)
        
        onNextVideoButtonAction = { [weak self] in
            guard let strongSelf = self else {return}
            if let showIndex = strongSelf.viewModel.show.sequenceContentId?.firstIndex(where: {$0._id == strongSelf.viewModel.show._id}) {
                strongSelf.viewModel.getDetailsData(withId: strongSelf.viewModel.show.sequenceContentId?[showIndex + 1]._id ?? "")
            }
                        
        }
    }
    
    func currencyConversion(){
        if viewModel.user.currencyRate != ""{
//            let price = SharedDataManager.shared.multiple(lhs: Double(viewModel.show.payPerViewPrice ?? "0.0") ?? 0.0, rhs: Double(viewModel.user.currencyRate) ?? 0.0)
//            print(round(price * 100) / 100.0)
//            //viewModel.user.currencyType
//            priceLabel.text = "$ " + String(format: "%.2f", round(price * 100) / 100.0)
            
            let strPayPerViewPrice = viewModel.show.payPerViewPrice ?? "0"
            if (strPayPerViewPrice.contains(".0")) || strPayPerViewPrice.contains(".00") {
                let ppayPerViewPrice = SharedDataManager.shared.multiple(lhs: Double(viewModel.show.payPerViewPrice ?? "0.0") ?? 0.0, rhs: Double(viewModel.user.currencyRate) ?? 0.0)
                print(round(ppayPerViewPrice * 100) / 100.0)
                //viewModel.user.currencyType
                priceLabel.text = "$ " + String(format: "%.2f", round(ppayPerViewPrice * 100) / 100.0)
            } else {
                priceLabel.text = "$ " + strPayPerViewPrice
            }
            
            
            let strBuyToOwnPrice = viewModel.show.buyToOwnPrice ?? "0"
            if (strBuyToOwnPrice.contains(".0")) || strBuyToOwnPrice.contains(".00") {
                let ownBuyprice = SharedDataManager.shared.multiple(lhs: Double(viewModel.show.buyToOwnPrice ?? "0.0") ?? 0.0, rhs: Double(viewModel.user.currencyRate) ?? 0.0)
                print(round(ownBuyprice * 100) / 100.0)
                //viewModel.user.currencyType
                buyOwnpriceLabel.text = "$ " + String(format: "%.2f", round(ownBuyprice * 100) / 100.0)
            } else {
                buyOwnpriceLabel.text = "$ " + strBuyToOwnPrice
            }
        }else{
            priceLabel.text = viewModel.show.payPerViewPrice?.currencyAppended
            buyOwnpriceLabel.text = viewModel.show.buyToOwnPrice?.currencyAppended
        }
    }
   
    @objc func reloadShow(){
        viewModel.getDetailsData(withId: self.viewModel.show._id ?? "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewAppeared()
        NSObject.cancelPreviousPerformRequests(withTarget: self.viewModel)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if viewModel.sessionCreated {
            if viewModel.show.isPurchased {
                let time = VideoPlayerManager.shared.currentVideoPlayerView?.currentSeekTime
                if time != 0{
                    let currentTimeString = viewModel.stringFromTimeInterval(interval: time ?? 0)
                    print(currentTimeString as Any)
                    
                    viewModel.savedPlayTime(currentTime: currentTimeString)
                }
            }
            
            //self.stopPlayer()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    @IBAction func buyOwnButtonAction(_ sender: UIButton) {
        if self.viewModel.sessionCreated {
            self.stopPlayer()
        }
        viewModel.buyToOwnBottomButtonTapped()
    }
    @IBAction func watchNowButtonTapped(_ sender: Any?) {
        if self.viewModel.sessionCreated {
            self.stopPlayer()
        }
        viewModel.watchNowBottomButtonTapped()
    }
    
    override func backButtonTapped(_ sender: Any?) {
        self.stopPlayer()
        delay(1.0){
            if self.viewModel.isCome == "UniversalLink" {
                KAPPDELEGATE.updateRootController(HomeViewController.getController(), transitionDirection: .toBottom, embedInNavigationController: false)
            } else {
                super.backButtonTapped(sender)
            }
        }
    }
    
    func stopPlayer() {
        DispatchQueue.main.async {
            if let urlAsset = self.viewModel.show.urlAsset,
               VideoPlayerManager.shared.isPlayingAsset(asset: urlAsset) {
                let time = VideoPlayerManager.shared.currentVideoPlayerView?.currentSeekTime
                if time != 0{
                    VideoPlayerManager.shared.startPipController()
                    self.viewModel.stopPlayingTrailerVideo()
                    self.viewModel.stopPlayingVideo()
                }else{
                    self.viewModel.stopPlayingVideo()
                    self.viewModel.stopPlayingTrailerVideo()
                }

            }
            else{
                self.viewModel.stopPlayingTrailerVideo()
                self.viewModel.stopPlayingVideo()
            }
        }
    }
}


extension LandingViewController : PiPListner{
    func pipListnerCallBack(){
        
    }
}
