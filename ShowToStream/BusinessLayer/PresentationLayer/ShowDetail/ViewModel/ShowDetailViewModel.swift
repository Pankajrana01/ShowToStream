//
//  ShowDetailViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import StoreKit
class ShowDetailViewModel: BaseViewModel {
    var user = UserModel.shared.user
    var sessionCreated: Bool = false
    var show: Show!
    var isCome = ""
    var universal_showId = ""
    var showFullDescription = false
    var similarShows: [Show] = []
    
    var bottomView = UIView()
    var buToOwnView: GradientView!
    var payPerView: GradientView!
    var buyToOwnBottomConstraints: NSLayoutConstraint!
    
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    var productsArray = [SKProduct]()
    
    override func viewLoaded() {
        super.viewLoaded()
        sessionCreated = KUSERMODEL.isLoggedIn()
        syncPreferences()
        getDetailsData(withId: show._id ?? "")
    }

    func viewAppeared() {
        if isCome == "pip" {
            isCome = ""
            VideoPlayerViewController.show(from: self.hostViewController, asset: show.urlAsset!, show: show, similarShows: similarShows)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func syncPreferences() {
        var selecedCategoryIds = [String]()
        KAPPSTORAGE.categories.forEach( { selecedCategoryIds.append($0._id) } )

        var selecedGenreIds = [String]()
        KAPPSTORAGE.genres.forEach( { selecedGenreIds.append($0._id) } )

        //check for user session ...
        if !self.sessionCreated {
            let params: [String: Any] = [WebConstants.contentId: show._id ?? ""]
            self.processDataForMayYouLike(params: params)
        }else{
            let param: [String: Any] = [WebConstants.profileId: KUSERMODEL.selectedProfile._id!, WebConstants.contentId: show._id ?? ""]
            self.processDataForLoginMayYouLike(params: param)
        }
    }

    //    If paymentType ==0 {
    //    Buy to own or paper == 0 — hide  / 1 show.    Payperview -1  buyownOn-2
    //    }
    //     Else paymentType == 1{
    //             payPerView == hide       buytOown == 1 - show — 0 - hide }
    //    Else paymentType == 2{
    //             payPerView == hide == buyOnOwn — timer hide.. }


//    func isShowPurchased(){
//        if show.isPurchased {
//            if show.paymentType == "2" {
//                buToOwnView.isHidden = true
//                payPerView.isHidden = true
//            } else {
//                payPerView.isHidden = true
//                if show.buyToOwnStatus == true{
//                    buToOwnView.isHidden = false
//                } else {
//                    buToOwnView.isHidden = true
//                }
//            }
//        } else {
//            if show.buyToOwnStatus == true{
//                buToOwnView.isHidden = false
//            } else {
//                buToOwnView.isHidden = true
//            }
//            if show.payPerViewStatus == true{
//                payPerView.isHidden = false
//            } else {
//                payPerView.isHidden = true
//            }
//        }
//    }
    
    func isShowPurchased(){
        if show.isPurchased {
            if show.paymentType == "2"{
                payPerView.isHidden = true
                buToOwnView.isHidden = true
                bottomView.isHidden = true
            }
            else if show.paymentType == "1"{
                payPerView.isHidden = true
                bottomView.isHidden = false
                buyToOwnBottomConstraints.constant = 3

                if show.buyToOwnStatus {
                    buToOwnView.isHidden = false
                }else {
                    buToOwnView.isHidden = true
                    buyToOwnBottomConstraints.constant = 3
                }
            } else {
                bottomView.isHidden = false
                payPerView.isHidden = false
                buToOwnView.isHidden = false

                if show.buyToOwnStatus {
                    buToOwnView.isHidden = false

                    if show.payPerViewStatus{
                        payPerView.isHidden = true
                        buyToOwnBottomConstraints.constant = 3
                    } else {
                        payPerView.isHidden = false
                        buyToOwnBottomConstraints.constant = 64
                    }
                } else {
                    buToOwnView.isHidden = true

                    if show.payPerViewStatus {
                        payPerView.isHidden = true
                        buyToOwnBottomConstraints.constant = 3
                    } else {
                        payPerView.isHidden = false
                        buyToOwnBottomConstraints.constant = 64
                    }
                }
            }
        } else {
            payPerView.isHidden = false
            bottomView.isHidden = false
            if show.buyToOwnStatus{
                buToOwnView.isHidden = false
            } else {
                buToOwnView.isHidden = true
            }
        }
    }



    func getDetailsData(withId: String){
        var parms = [String:Any]()
        parms[WebConstants.id] = withId

        if KUSERMODEL.isLoggedIn() {
            parms[WebConstants.profileId] = KUSERMODEL.selectedProfile._id!
        }

        if !self.sessionCreated {
            self.processDataForDetailContent(params: parms)
        }
        else{
            self.processDataForLoginDetailContent(params: parms)
        }
    }

    private func configureCollectionView() {
        collectionView.collectionViewLayout = compositionalLayout

        //        var top: CGFloat = 0
        //
        //        if let window = KAPPDELEGATE.window,
        //           window.safeAreaInsets.top > 0 {
        //            top = -window.safeAreaInsets.top
        //        }


        let top: CGFloat = 0
        if show.isPurchased {
            collectionView.contentInset     = UIEdgeInsets(top: top, left: 0, bottom: 40, right: 0)
        } else {
            collectionView.contentInset     = UIEdgeInsets(top: top, left: 0, bottom: 140, right: 0)
        }


        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .scrollableAxes

        collectionView.register(UINib(nibName: NibCellIdentifier.showBannerCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.showBanner)

        collectionView.register(UINib(nibName: NibCellIdentifier.showDescriptionCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.showDescription)

        collectionView.register(UINib(nibName: NibCellIdentifier.homeShowCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.similarShows)

        collectionView.register(UINib(nibName: NibCellIdentifier.baseHeaderCollectionReusableViewNib, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionViewCellIdentifier.homeHeader)
    }

    func watchNowButtonTapped() {
        if !self.sessionCreated {
            self.checkforAccount()
        }else{
            if show.isPurchased {
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                DispatchQueue.main.async {
                    if let cell = self.collectionView.visibleCells.first(where: { $0 is VideoPlayerInCollectionViewCell }) as? VideoPlayerInCollectionViewCell {
                        self.playVideo(cell: cell)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let cell = self.collectionView.visibleCells.first(where: { $0 is VideoPlayerInCollectionViewCell }) as? VideoPlayerInCollectionViewCell {
                        self.autpPlayTrailer(cell: cell)
                    }
                }
            }
        }
    }

    func watchNowBottomButtonTapped() {
           if !self.sessionCreated {
               checkforAccount()
               stopPlayingTrailerVideo()
               //
           } else {
            stopPlayingTrailerVideo()

               delay(1.0){
                   let contentId = self.show._id!.aesCryptoJS
                   let userId = self.user.id.aesCryptoJS
                   let accessToken = self.user.accessToken.aesCryptoJS

                   let paymentUrl = "https://web.showtostream.com/ios-payment?contentId=" + "\(contentId)" +
                   "&userId=" + "\(userId)" +
                   "&profileId=" + "\(KUSERMODEL.selectedProfile._id!)".aesCryptoJS +
                   "&accessToken=" + "\(accessToken)" +
                   "&sessionId=" + "\(self.user.sessionId.aesCryptoJS)" +
                   "&payment_type=1"

                   print("paymentUrl - > \(paymentUrl)")

                   if !self.show.isDanceStudioPrivate{
                       self.openPaymentWebPage(title: "Payment", url: paymentUrl)
                   }else{
                       self.verifyShowWithPin(url: paymentUrl)
                   }

               }
           }
       }

    func buyToOwnBottomButtonTapped() {
           if !self.sessionCreated {
               checkforAccount()
               stopPlayingTrailerVideo()
               //
           } else {
            stopPlayingTrailerVideo()

               delay(1.0){
                   let contentId = self.show._id!.aesCryptoJS
                   let userId = self.user.id.aesCryptoJS
                   let accessToken = self.user.accessToken.aesCryptoJS

                   let paymentUrl = "https://web.showtostream.com/ios-payment?contentId=" + "\(contentId)" +
                   "&userId=" + "\(userId)" +
                   "&profileId=" + "\(KUSERMODEL.selectedProfile._id!)".aesCryptoJS +
                   "&accessToken=" + "\(accessToken)" +
                   "&sessionId=" + "\(self.user.sessionId.aesCryptoJS)" +
                   "&payment_type=2"

                   print("paymentUrl - > \(paymentUrl)")

                   if !self.show.isDanceStudioPrivate{
                       self.openPaymentWebPage(title: "Payment", url: paymentUrl)
                   }else{
                       self.verifyShowWithPin(url: paymentUrl)
                   }

               }
           }
       }

       func openPaymentWebPage(title:String, url:String){
           stopPlayingTrailerVideo()
           WebPageViewController.show(from: hostViewController, forcePresent: false, title: title, url: url, iscomeFrom: "payment"){ status in
               print(status)
               if status{
                   self.syncPreferences()
                   self.getDetailsData(withId: self.show._id ?? "")
               }
           }
       }

    func stopPlayingTrailerVideo(){
        DispatchQueue.main.async {
            if let cell = self.collectionView.visibleCells.first(where: { $0 is TrailerPlayerInCollectionViewCell }) as? TrailerPlayerInCollectionViewCell {
                cell.stopPlayingTrailer()
            }
        }
    }

    func stopPlayingVideo(){
        DispatchQueue.main.async {
            if let cell = self.collectionView.visibleCells.first(where: { $0 is VideoPlayerInCollectionViewCell }) as? VideoPlayerInCollectionViewCell {
                cell.stopPlayingVideo()
            }
        }
    }
    ////////
//    func watchNowBottomButtonTapped() {
//        if !self.sessionCreated {
//            checkforAccount()
//            stopPlayingTrailerVideo()
//            //
//        }else{
//            // Dance Studio show is private ...
//            if !show.isDanceStudioPrivate{
//                showWorkInProgress()
//            }else{
//                verifyShowWithPin()
//            }
//            stopPlayingTrailerVideo()
//        }
//    }

    func verifyShowWithPin(url:String){
        VerifyShowViewController.show(from: self.hostViewController, forcePresent: false,id: show._id!, url: url) { status in
        }
    }

    func playVideo(cell: VideoPlayerInCollectionViewCell) {
        // if trailer is not played already, cancel the trailer timer.
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        cell.playVideo(in: self.hostViewController)
    }

    func checkforAccount(){
        let controller = CheckAccountViewController.getController() as! CheckAccountViewController
        controller.dismissCompletion = {
            DispatchQueue.main.async {
                if let cell = self.collectionView.visibleCells.first(where: { $0 is VideoPlayerInCollectionViewCell }) as? VideoPlayerInCollectionViewCell {
                   // self.autpPlayTrailer(cell: cell)
                }
            }
        }
        controller.show(over: self.hostViewController) { status in
        }
    }

//    func shareShow(showName:String) {
//        let shareText = APPNAME + " - " + showName
//        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
//        if let popOver = vc.popoverPresentationController {
//            popOver.sourceView = self.bottomView
//            popOver.sourceRect = self.bottomView.bounds
//        }
//
//        var parentController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
//        while (parentController?.presentedViewController != nil &&
//                parentController != parentController!.presentedViewController) {
//            parentController = parentController!.presentedViewController
//        }
//
//        parentController?.present(vc, animated: true)
//
//    }

    func savedPlayTime(currentTime:String){
        if currentTime != ""{
            var parms = [String:Any]()
            parms[WebConstants.playDuration] = currentTime
            parms[WebConstants.contentId] = show._id
            processDataForSaveWatchDuration(params: parms)
        }
    }

    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti: Int = Int(interval)
        let seconds: Int = ti % 60
        let minutes: Int = (ti / 60) % 60
        let hours: Int = (ti / 3600)
        var time: String? = nil
        time = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return time!
    }
}
extension ShowDetailViewModel {
    //MARK: Api for Guest User ...
    func processDataForDetailContent(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.HomeCommon.contentDetails,
                               params: params,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String:Any]
                                    self.show.updateWithDetailData(responseData)
                                    self.isShowPurchased()
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                }
                                hideLoader()
        }
    }
    func processDataForMayYouLike(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.HomeCommon.mayLikeVideos,
                               params: params,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.similarShows = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject)
                                        showList.append(show)
                                    }
                                    self.similarShows.append(contentsOf: showList)
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                }
                                hideLoader()
        }
    }



    // ---------------------------
    //MARK: Api for Login User ...
    func processDataForLoginDetailContent(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.contentDetails,
                               params: params,
                               headers: headers,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String:Any]
                                    self.show.updateWithDetailData(responseData)
                                    self.isShowPurchased()
                                    VideoPlayerManager.shared.currentVideoPlayerView?.updateFeedBackView(show: self.show, hideViews: true)

                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()

                                    }
                                }
                                hideLoader()
        }
    }
    func processDataForLoginMayYouLike(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.mayLikeVideos,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.similarShows = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject)
                                        showList.append(show)
                                    }
                                    self.similarShows.append(contentsOf: showList)
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                }
                                hideLoader()
        }
    }
    
    func processDataForReport(contentId:String) {
        
        let alert = UIAlertController(title: "ShowToStream", message: "Are you sure you want to report this content?",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
                alert.addAction(UIAlertAction(title: "Yes",
                                              style: UIAlertAction.Style.default,
                                              handler: {(_: UIAlertAction!) in
                    self.APIReportContent(contentId: contentId)
                }))
                self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    func APIReportContent(contentId:String) {
        showLoader()
        var params = [String:Any]()
        //params[WebConstants.reason] = "Reason Detail"
        //user.id
        params[WebConstants.contentId] = contentId

        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]

        ApiManager.makeApiCall(APIUrl.MyAccount.contentReport,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                        showSuccessMessage(with: StringConstants.contentReported)
                                        //self.getDetailsData()
                                }
                                hideLoader()
        }
    }
    
    
    func processDataForAddToWatchList(contentId:String) {
       // showLoader()
        var params = [String:Any]()
        params[WebConstants.profileId] = KUSERMODEL.selectedProfile._id!
        //user.id
        params[WebConstants.contentId] = contentId

        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]

        ApiManager.makeApiCall(APIUrl.Profile.addToWatchList,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if response?[WebConstants.responseType] as? String == WebConstants.watchListAlreadyExit{
                                        showMessage(with: response![WebConstants.responseType] as! String)
                                    }else{
                                        showSuccessMessage(with: StringConstants.watchlistAdded)
                                        //self.getDetailsData()
                                    }
                                }
                                hideLoader()
        }
    }
    
    func processDataForRemoveWatchList(params: [String: Any]) {
        //showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.removeWatchList,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    showMessage(with: StringConstants.watchlistRemove)
                                    //self.getDetailsData()
                                }
                                hideLoader()
        }
    }

    func processDataForSaveWatchDuration(params: [String: Any]) {
        //showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.saveContinueWatchTime,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                }
                                hideLoader()
        }
    }
}

//Handle In-App purchase ...
extension ShowDetailViewModel {
    func fetchProductsIAP(){
        InAppPurchaseHandler.shared.setProductIds(ids: INAPP_PRODUCTIDs)
        InAppPurchaseHandler.shared.fetchAvailableProducts { [weak self](products)   in
            guard let sSelf = self else {return}
            sSelf.productsArray = products
        }
    }

    func proceefForPayment(){
        InAppPurchaseHandler.shared.purchase(product: self.productsArray[0]) { (alert, product, transaction) in
            if let tran = transaction, let prod = product {
                //use transaction details and purchased product as you want
                print(tran, prod)
                print(tran.transactionIdentifier as Any, tran.transactionDate as Any, tran.transactionState)
                print(prod.productIdentifier, prod.price, prod.priceLocale )
                let transactionID = "\(tran.transactionIdentifier ?? "")"
                //self.buyNow(payType:selectedID, payPrice:, transactionID: self.transactionID)
            }

            //  Globals.shared.showWarnigMessage(alert.message)
        }
    }

}
    
    
    
  
