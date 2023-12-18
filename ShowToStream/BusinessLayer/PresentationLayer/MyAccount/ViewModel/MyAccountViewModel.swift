//
//  MyAccountViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 16/12/20.
//

import UIKit

class MyAccountViewModel: BaseViewModel {
    var profiles = KUSERMODEL.user.profiles
    var isPresenter: Bool = false
    var completionHandler: ((Bool) -> Void)?
    var isShowCancel = false
    var user = KUSERMODEL.user
    var earning = ""
    private var myAccountOption: [MyAccount] = []
    var commonUrls = [CommonUrl]()

    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: NibCellIdentifier.userProfileCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.userProfileCollectionViewCell)
    }
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.register(UINib(nibName: TableViewNibIdentifier.myAccountTableCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.myAccountTableCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.presenterTableCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.presenterTableCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.earningTableCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.earningTableCell)
    }
    
    override func viewLoaded() {
        super.viewLoaded()
        updateUserDetails()
        myAccountOption.append(MyAccount(name: StringConstants.myAccount, image: #imageLiteral(resourceName: "ic_user"), desc: ""))
        myAccountOption.append(MyAccount(name: StringConstants.playonTV, image: #imageLiteral(resourceName: "ic_tv"), desc: ""))
        myAccountOption.append(MyAccount(name: StringConstants.savedCards, image: #imageLiteral(resourceName: "ic_card"), desc: ""))
       // myAccountOption.append(MyAccount(name: StringConstants.streamingQuality, image: #imageLiteral(resourceName: "ic_streaming"), desc: StringConstants.good))
        myAccountOption.append(MyAccount(name: StringConstants.preferences, image: #imageLiteral(resourceName: "ic_preference"), desc: KUSERMODEL.displaybleCategories))
        
        myAccountOption.append(MyAccount(name: StringConstants.aboutShowToStream, image: #imageLiteral(resourceName: "ic_doc"), desc: ""))
        
        myAccountOption.append(MyAccount(name: StringConstants.termsOfServices, image: #imageLiteral(resourceName: "ic_terms_condition"), desc: ""))
        
        myAccountOption.append(MyAccount(name: StringConstants.privacyPolicy, image: #imageLiteral(resourceName: "ic_privacy_policy"), desc: ""))
        
//        myAccountOption.append(MyAccount(name: StringConstants.legal, image: #imageLiteral(resourceName: "ic_doc"), desc: ""))
        myAccountOption.append(MyAccount(name: StringConstants.faqs, image: #imageLiteral(resourceName: "ic_faq"), desc: ""))
        
        myAccountOption.append(MyAccount(name: StringConstants.contactUs, image: #imageLiteral(resourceName: "ic_contact"), desc: ""))
        
        // load common Url's
        KAPPDELEGATE.shouldRefreshCommonUrls = true
        KAPPDELEGATE.loadData { urls in
            self.commonUrls = urls!
        }
    }
    
    func updateUserDetails(){
        var params = [String: Any]()
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        self.processUpdateUserData(params: params)
    }
    
    private func myAccountButtonTapped() {
        UserAccountDetailViewController.show(from: self.hostViewController, forcePresent: false)
    }
    
    private func aboutButtonTapped(){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: StringConstants.about, url: self.commonUrls[0].url, iscomeFrom: ""){ status in
        }
    }
    
    private func termsButtonTapped(){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: StringConstants.termsOfServices, url: self.commonUrls[4].url, iscomeFrom: ""){ status in
        }
    }
    
    private func privacyButtonTapped(){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: StringConstants.privacyPolicy, url: self.commonUrls[2].url, iscomeFrom: ""){ status in
        }
    }
    
    private func legalButtonTapped(){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: StringConstants.legal, url: self.commonUrls[3].url, iscomeFrom: ""){ status in
        }
//        AboutViewController.show(from: hostViewController, forcePresent: false, openUrl: "", title: StringConstants.legal) { success in
//            if success { }
//        }
        
    }
    
    private func faqButtonTapped(){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: StringConstants.faq, url: self.commonUrls[1].url, iscomeFrom: ""){ status in
        }
    }
    
    private func contactUsButtonTapped(){
        ContactUsViewController.show(from: hostViewController, forcePresent: false) { success in
            if success { }
        }
        
    }
    
    private func becomePresenterButtonTapped(){
        BecomePresenterViewController.show(from: hostViewController, forcePresent: true) { success in
            if success { }
        }
        
    }
    
    func manageProfileButtonTapped(index: Int){
        ManageProfileViewController.show(from: hostViewController, forcePresent: true, profile  : profiles[index], canDeleteProfile: profiles.count == 2) {
            self.profiles = KUSERMODEL.user.profiles
            self.collectionView.reloadData()
        }
    }
    
    func addProfileButtonTapped(){
        ManageProfileViewController.show(from: hostViewController, forcePresent: true, canDeleteProfile: false) {
            self.profiles = KUSERMODEL.user.profiles
            self.collectionView.reloadData()
            self.hostViewController.dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func playonTvButtonTapped(){
        PlayTvViewController.show(from: hostViewController, forcePresent: false) { success in
            if success { }
        }
        
    }
    
    private func streamQualityButtonTapped(){
        let controller = StreamQualityViewController.getController() as! StreamQualityViewController
        controller.dismissCompletion = { }
        controller.show(over: self.hostViewController) { status in
        }
    }
    
    private func earningButtonTapped(){
        EarningsViewController.show(from: self.hostViewController)
    }
    
    private func preferencesTapped() {
        PreferenceViewController.show(from: self.hostViewController, profile: KUSERMODEL.selectedProfile) {
            if let accountOption = self.myAccountOption.first(where: { $0.name == StringConstants.preferences
            }) {
                accountOption.desc = KUSERMODEL.displaybleCategories
                self.hostViewController.navigationController?.popToViewController(self.hostViewController, animated: true)
            }
        }
    }
    
    fileprivate func profileButtonTapped(at index: Int) {
        var params = [String: Any]()
        params[WebConstants.id] = profiles[index]._id
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceName] = DEVICENAME
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        processData(params: params)
        KUSERMODEL.selectedProfileIndex = index
    }
    
    fileprivate func profileSelected() {
        if KUSERMODEL.selectedProfile.preferencesSet {
            let controller = LandingViewController.getController()
            controller.clearNavigationStackOnAppear = true
            controller.show(from: self.hostViewController)
        } else {
            PreferenceViewController.show(from: self.hostViewController, profile: KUSERMODEL.selectedProfile) {
                let controller = LandingViewController.getController()
                controller.clearNavigationStackOnAppear = true
                controller.show(from: self.hostViewController)
            }
        }
    }
    
    func savedCardTapped(){
        let accessToken = user.accessToken
   // https://web.showtostream.com - dev
        // https://www.showtostream.com - live
        let savedCardUrl = "https://web.showtostream.com/ios-saved-card?token=" + accessToken
        self.openPaymentWebPage(title: "Saved Card", url: savedCardUrl)
    }
    
    func openPaymentWebPage(title:String, url:String){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: title, url: url, iscomeFrom: ""){ status in
            
        }
    }
}

extension MyAccountViewModel : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return myAccountOption.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.earningTableCell) as? EarningTableCell{
                cell.earningLabel.text = self.earning
                cell.currencyLabel.text = "$"
//                if user.currencyRate != ""{
//                    cell.currencyLabel.text = "\(user.currencyType)"
//                }else{
//                    cell.currencyLabel.text =  "".currencyAppended
//                }
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.myAccountTableCell) as? MyAccountTableCell{
                cell.optionName.text = myAccountOption[indexPath.row].name
                cell.optionImage.image = myAccountOption[indexPath.row].image
                cell.optionDesc.text = myAccountOption[indexPath.row].desc
                if myAccountOption[indexPath.row].desc == ""{
                    cell.TitleTopConstraint.constant = 0
                }else{
                    cell.TitleTopConstraint.constant = -5
                }
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.presenterTableCell) as? PresenterTableCell{
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: 
            earningButtonTapped()
        case 1:
            if indexPath.row == 0{
                myAccountButtonTapped()
            }
            else if indexPath.row == 1{
                playonTvButtonTapped()
            }
            else if indexPath.row == 2{
                savedCardTapped()
            }
//            else if indexPath.row == 3{
//                streamQualityButtonTapped()
//            }
            else if indexPath.row == 3{
                preferencesTapped()
            }
            else if indexPath.row == 4{
                aboutButtonTapped()
            }
            else if indexPath.row == 5{
                termsButtonTapped()
            }
            else if indexPath.row == 6{
                privacyButtonTapped()
            }
           /* else if indexPath.row == 5{
                legalButtonTapped()
            }*/
            else if indexPath.row == 7{
                faqButtonTapped()
            }
            else if indexPath.row == 8{
                contactUsButtonTapped()
            }
        case 2:
            self.becomePresenterButtonTapped()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if isPresenter == true{
                if UIDevice.current.userInterfaceIdiom  == .pad{
                    return 180.0
                }else{
                    return 150.0
                }
            }else{
                return 0.0
            }
        case 1:
            if UIDevice.current.userInterfaceIdiom  == .pad{
                return 102.0
            }else{
                return 72.0
            }
        case 2:
            if isPresenter == true{
                return  0.0
            }else{
                if UIDevice.current.userInterfaceIdiom  == .pad{
                    return 130.0
                }else{
                    return 100.0
                }
            }
        default:
            return 0.0
        }
    }
    
}
extension MyAccountViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    private func configureCell(_ cell: UserProfileCollectionViewCell, with profile: Profile) {
        if isShowCancel == true{
            cell.transparentView.isHidden = false
        } else {
            cell.transparentView.isHidden = true
        }
        
        cell.accountProfileUsername.text = profile.profileName
        cell.accountProfileUserImage.image = profile.avatarImage
        cell.accountProfileView.isHidden = false
        cell.userAddProfileView.isHidden = true
        
        cell.accountProfileBgView.layer.cornerRadius = cell.accountProfileBgView.frame.size.height/2
        cell.transparentView.layer.cornerRadius = cell.transparentView.frame.size.height/2
        
        cell.accountProfileBgView.layer.borderWidth = KUSERMODEL.selectedProfile == profile ? 1 : 0
        cell.accountProfileBgView.layer.borderColor = UIColor.white.cgColor
        cell.accountProfileBgView.clipsToBounds = true
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.userProfileCollectionViewCell, for: indexPath) as! UserProfileCollectionViewCell
        cell.userProfileView.isHidden = true
        
        switch indexPath.row {
        case 0:
            configureCell(cell, with: profiles[indexPath.row])
        case 1:
            if profiles.count == 2 {
                configureCell(cell, with: profiles[indexPath.row])
            } else {
                cell.addUserName.text = StringConstants.addNew
                cell.addUserImage.image = #imageLiteral(resourceName: "img_add_avatar")
                cell.userProfileView.isHidden = true
                cell.accountProfileView.isHidden = true
                cell.userAddProfileView.isHidden = false
            }
        default:
            break
        }
        cell.transparentView.clipsToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if isShowCancel == true {
                manageProfileButtonTapped(index: indexPath.row)
            }else{
                profileButtonTapped(at: indexPath.row)
            }
        case 1:
            if profiles.count == 2 {
                if isShowCancel == true {
                    manageProfileButtonTapped(index: indexPath.row)
                }else{
                    profileButtonTapped(at: indexPath.row)
                }
            } else {
                addProfileButtonTapped()
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: 80, height: 100)
        }
}


extension MyAccountViewModel {
    
    func processUpdateUserData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
            }
            hideLoader()
        }
    }
    func processData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.selectProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    self.profileSelected()
                                }
                                hideLoader()
        }
    }
    func processDataForEarning() {
        //showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.presenterEarnings,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let dataDict = response?[APIConstants.data] as! NSDictionary
                                    let totalEarnings = dataDict["totalEarnings"] as? Double
                                    let totalStripeFee = dataDict["totalStripeFee"] as? Double
                                    let requiredEarning = (Double(totalEarnings ?? Double(0.0)) - (Double((totalStripeFee ?? Double(0.0))) / Double(100.0)))
                                    let strReqEarning = "\(requiredEarning)"
                                    if strReqEarning.contains(".0") || strReqEarning.contains(".00") {
                                        self.earning = "\(Int(requiredEarning))"
                                    } else {
                                        self.earning = "\(requiredEarning)"
                                    }
                                    self.processCurrencyData()
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
                if self.tableView != nil{
                    self.tableView.reloadData()
                }
            }
            hideLoader()
        }
    }
}
