//
//  HomeViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class HomeViewModel: BaseViewModel {
    var user = KUSERMODEL.user
    var sessionCreated: Bool = false
    var categories: [PreferenceCategory] = SharedDataManager.shared.categories
    var group = DispatchGroup()
    var topBannerItems: [Show] = []
    var continueWatching: [Show] = []
    var recommendedForYou: [Show] = []
    var top10: [Show] = []
    var popularNow: [Show] = []
    var show : [Show] = []
    var selectedCategories: [Concert] = []
    var concertName = [String]()
    var timerArray = [Date]()
    private var isLoading: Bool = false
    private var hasLoadedOnce: Bool = false
    lazy var refreshTimer = Timer()
    
    var showShimmer: Bool {
        return isLoading && !hasLoadedOnce
    }
    
    var isSkeletonable  = true
    
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.collectionViewLayout = compositionalLayout
        
        var top: CGFloat = 0
        
        if let window = KAPPDELEGATE.window,
           window.safeAreaInsets.top > 0 {
            top = -window.safeAreaInsets.top
        }
        
        if UIDevice.current.userInterfaceIdiom  == .phone{
            collectionView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 80, right: 0)
        }else{
            collectionView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 110, right: 0)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: NibCellIdentifier.baseTileCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.categories)
        
        collectionView.register(UINib(nibName: NibCellIdentifier.homeShowCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.homeShow)
        
        collectionView.register(UINib(nibName: NibCellIdentifier.bannerShowsCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.homeBannerShow)
        
        collectionView.register(UINib(nibName: NibCellIdentifier.continueWatchingShowCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.continueWatchingShow)

        collectionView.register(UINib(nibName: NibCellIdentifier.baseHeaderCollectionReusableViewNib, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionViewCellIdentifier.homeHeader)
        
        collectionView.register(UINib(nibName: NibCellIdentifier.viewMoreCollectionViewCell, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.viewMore)
    }

    override func viewLoaded() {
        super.viewLoaded()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(stopPlayingTrailer), name: Notification.Name.stopPlayingTrailer, object: nil)
        
       // nc.addObserver(self, selector: #selector(continuePlayingTrailer), name: Notification.Name.continuePlayingTrailer, object: nil)
        
        nc.addObserver(self, selector: #selector(showDetailScreen), name: Notification.Name.pipListner, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func showDetailScreen(notification: NSNotification){
        if let obj = notification.object{
            let showObj : Show = obj as! Show
            ShowDetailViewController.show(from: self.hostViewController, show: showObj, isCome: "pip", universal_showId: "")
        }
    }
    
    @objc func stopPlayingTrailer(){
        DispatchQueue.main.async {
            if let cell = self.collectionView.visibleCells.first(where: { $0 is TrailerPlayerInCollectionViewCell }) as? TrailerPlayerInCollectionViewCell {
                cell.stopPlayingTrailer()
            }
        }
    }
    @objc func continuePlayingTrailer(){
        DispatchQueue.main.async {
            if let cell = self.collectionView.visibleCells.first(where: { $0 is TrailerPlayerInCollectionViewCell }) as? TrailerPlayerInCollectionViewCell {
                cell.playTrailer(in: self.hostViewController)
            }
        }
    }
    func checkforAccount(){
        let controller = CheckAccountViewController.getController() as! CheckAccountViewController
        controller.dismissCompletion = {
            //self.continuePlayingTrailerVideo()
        }
        controller.show(over: self.hostViewController) { status in
        }
    }
    
    func continuePlayingTrailerVideo(){
        DispatchQueue.main.async {
            if let cell = self.collectionView.visibleCells.first(where: { $0 is TrailerPlayerInCollectionViewCell }) as? TrailerPlayerInCollectionViewCell {
                cell.playTrailer(in: self.hostViewController)
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
}

extension HomeViewModel {
    func avatarButtonTapped() {
        stopPlayingTrailerVideo()
        if KUSERMODEL.isLoggedIn() {
            MyAccountViewController.show(from: self.hostViewController, forcePresent: false) { status in
            }
        } else {
            self.checkforAccount()
        }
    }
}
extension HomeViewModel {
    func syncPreferences() {
        var selecedCategoryIds = [String]()
        KAPPSTORAGE.categories.forEach( { selecedCategoryIds.append($0._id) } )
        
        var selecedGenreIds = [String]()
        KAPPSTORAGE.genres.forEach( { selecedGenreIds.append($0._id) } )
        
        //check for user session ...
        if !self.sessionCreated {
           callGuestUserApi(selecedCategoryIds: selecedCategoryIds, selecedGenreIds: selecedGenreIds)
        }else{
            processCurrencyData()
            callLoginUserApi()
        }
    }
// Add watchlist api
    func processDataForAddToWatchList(contentId:String) {
        showLoader()
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
                                    }
                                }
                                hideLoader()
        }
    }
    // remove watchlist api
    func processDataForRemoveWatchList(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.removeWatchList,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    showMessage(with: StringConstants.watchlistRemove)
                                   
                                }
                                hideLoader()
        }
    }
    
    //MARK: Call Api for Guest in user ...
    func callGuestUserApi(selecedCategoryIds:[String], selecedGenreIds:[String]){
        let params: [String: Any] = [WebConstants.categoryIds: selecedCategoryIds,
                                     WebConstants.genreIds: selecedGenreIds]
        // adding dispatch group for handling multiple api calls simultanously...
        self.group.enter()
        self.processDataForGetTrending()
        
        self.group.enter()
        self.processDataForCommonRecommended(params: params)
        
        self.group.enter()
        let param: [String: Any] = [WebConstants.categoryIds: selecedCategoryIds]
        self.processDataForConcert(params: param)
        
        self.group.enter()
        self.processDataForTopTenRated()
        
        self.group.enter()
        self.processDataForPopular()
        
        self.group.notify(queue: .main) {
            // whatever you want to do when both are done
          //  self.collectionView.reloadData()
        }
    }
    //MARK: Call Api for logged in user ...
    func callLoginUserApi(){
        let params: [String: Any] = [WebConstants.profileId: KUSERMODEL.selectedProfile._id!]
        // add dispatch group for handling multiple api calls simultanously...
        
        self.group.enter()
        self.processDataForLoginGetTrending()
        
        self.group.enter()
        self.processDataForLoginContinueList()

        self.group.enter()
        self.processDataForLoginCommonRecommended(params: params)

        self.group.enter()
        self.processDataForLoginConcert(params: params)

        self.group.enter()
        self.processDataForTopTenRated()

        self.group.enter()
        self.processDataForPopular()
    
        self.group.notify(queue: .main) {
            // whatever you want to do when both are done
           //self.collectionView.reloadData()
        }
    }
    
    //MARK: Api for Guest user ...
    func processDataForCommonRecommended(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.HomeCommon.getRecommendedContent,
                               params: params,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.recommendedForYou = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject)
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.recommendedForYou.append(contentsOf: showList)
                                   
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processDataForTopTenRated() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.Content.topten,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.top10 = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.top10.append(contentsOf: showList)
                                    
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processDataForPopular() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.Content.popular,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.popularNow = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.popularNow.append(contentsOf: showList)
                                    
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
   
    }
    
    func processDataForGetTrending() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.HomeCommon.trending,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.topBannerItems = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithTrendingData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.topBannerItems.append(contentsOf: showList)
                                    
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    
    func processDataForConcert(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.HomeCommon.danceConcert,
                               params: params,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String:Any]
                self.selectedCategories = [Concert]()
                
                for (key, data) in responseData {
                    let title = key
                    let responseArray = data as! [[String:Any]]
                    var showList = [Show]()
                    self.show = [Show]()
                    
                    for rawObject in responseArray {
                        let show = Show()
                        show.updateWithHomeData(rawObject)
                        showList.append(show)
                    }
                    
                    self.show.append(contentsOf: showList)
                    self.selectedCategories.append(Concert(title: title, show: self.show))
                    if self.collectionView != nil{
                        self.collectionView.reloadData()
                    }
                }
                self.group.leave()
            }
            hideLoader()
        }
    }
    // ---------------------------
    //MARK: Api for Login User ...
    func processDataForLoginCommonRecommended(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.getRecommended,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.recommendedForYou = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.recommendedForYou.append(contentsOf: showList)
                                    
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processDataForLoginTopTenRated(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.topten,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.top10 = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.top10.append(contentsOf: showList)
                                    
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processDataForLoginPopular(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.popular,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.popularNow = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.popularNow.append(contentsOf: showList)
                                    
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processDataForLoginGetTrending() {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.trending,
                               headers: headers,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.topBannerItems = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithTrendingData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.topBannerItems.append(contentsOf: showList)
                                    
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processDataForLoginConcert(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.danceConcert,
                               params: params,
                               headers: headers,
                                   method: .post) { response, _ in
                if !self.hasErrorIn(response) {
                    let responseData = response![APIConstants.data] as! [String:Any]
                    self.selectedCategories = [Concert]()
                    
                    for (key, data) in responseData {
                        let title = key
                        let responseArray = data as! [[String:Any]]
                        var showList = [Show]()
                        self.show = [Show]()
                        
                        for rawObject in responseArray {
                            let show = Show()
                            show.updateWithHomeData(rawObject)
                            showList.append(show)
                        }
                        
                        self.show.append(contentsOf: showList)
                        self.selectedCategories.append(Concert(title: title, show: self.show))
                    }
                    
                    if self.collectionView != nil{
                        self.collectionView.reloadData()
                    }
                    self.group.leave()
                }
                hideLoader()
            }
    }
    
    func processDataForLoginContinueList() {
        var params = [String:Any]()
        params[WebConstants.limit] = PageLimit.defaultLimit
        params[WebConstants.skip] = 0
       // params[WebConstants.profileId] = KUSERMODEL.selectedProfile._id!
        print(params)
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.continueList,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.show = [Show]()
                                    self.continueWatching = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithContinuelistData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.continueWatching.append(contentsOf: showList)
                                    self.bindData()
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processCurrencyData() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.Profile.currency,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .post) { response, _ in
            
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                print(self.user.currencyType, self.user.currencyRate)
            }
            hideLoader()
        }
    }
    // MARK:- Bind Data
    func bindData() {
        self.timerArray.removeAll()
        for index in 0 ..<  self.continueWatching.count  {
            let item = self.continueWatching[index]
            let timer = item.timeLeft ?? "00:00:00"
            //guard let timer = item.timeLeft else { return }
            if timer == "" {
                let seconds = 0
                let date =  Date(timeIntervalSinceNow: TimeInterval(seconds))
                self.timerArray.append(date)
            } else {
                let seconds = self.getTimerStartValueInSeconds(with: timer)
                let date =  Date(timeIntervalSinceNow: TimeInterval(seconds))
                self.timerArray.append(date)
            }
        }
    }
    
    private func getTimerStartValueInSeconds(with value:String) -> Int {
        let array = value.components(separatedBy: ":")
        let hours = (Int(array[0]) ?? 0) * 60 * 60
        let minutes = (Int(array[1]) ?? 0) * 60
        let seconds = (Int(array[2]) ?? 0)
        return Int(hours + minutes + seconds)
    }
    
    
}

extension MyAccountViewController : RequestMyAccountUpdatedListner{
    func requestMyAccountUpdated(Update: Bool) {
        if Update == true {
            self.viewModel.updateUserDetails()
        }
    }
}
