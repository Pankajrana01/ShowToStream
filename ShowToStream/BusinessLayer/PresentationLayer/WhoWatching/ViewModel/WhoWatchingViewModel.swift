//
//  WhoWatchingViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 04/01/21.
//

import Foundation
import UIKit

class WhoWatchingViewModel: BaseViewModel {
    
    var profiles = KUSERMODEL.user.profiles
    
    var completionHandler: ((Bool) -> Void)?
    
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
    
    override func viewLoaded() {
        super.viewLoaded()
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
    
    fileprivate func addProfileButtonTapped() {
        ManageProfileViewController.show(from: hostViewController, forcePresent: true, canDeleteProfile: false) {
            self.profiles = KUSERMODEL.user.profiles
            self.collectionView.reloadData()
            self.hostViewController.dismiss(animated: true, completion: nil)
        }
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
}

extension WhoWatchingViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    private func configureCell(_ cell: UserProfileCollectionViewCell, with profile: Profile) {
        cell.userName.text = profile.profileName
        cell.userImage.image = profile.avatarImage
        cell.userProfileView.isHidden = false
        cell.userAddProfileView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.userProfileCollectionViewCell, for: indexPath) as! UserProfileCollectionViewCell

        cell.accountProfileView.isHidden = true
        cell.transparentView.isHidden = true
        
        switch indexPath.row {
        case 0:
            if profiles.count != 0{
                configureCell(cell, with: profiles[indexPath.row])
            }
        case 1:
            if profiles.count == 2 {
                configureCell(cell, with: profiles[indexPath.row])
            } else {
                cell.addUserName.text = StringConstants.addNew
                cell.addUserImage.image = #imageLiteral(resourceName: "img_add_avatar")
                cell.userProfileView.isHidden = true
                cell.userAddProfileView.isHidden = false
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            profileButtonTapped(at: indexPath.row)
        case 1:
            if profiles.count == 2 {
                profileButtonTapped(at: indexPath.row)
            } else {
                addProfileButtonTapped()
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 115, height: 135)
        }
}

extension WhoWatchingViewModel {
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
}
