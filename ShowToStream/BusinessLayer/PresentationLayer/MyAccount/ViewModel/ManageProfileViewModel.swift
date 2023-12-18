//
//  ManageProfileViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 21/12/20.
//

import Foundation
import UIKit
class ManageProfileViewModel: BaseViewModel {
 
    var profile: Profile?
    var completionHandler: (() -> Void)?
    
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    var titleName: String  {
        return profile == nil ? StringConstants.newProfile : StringConstants.editProfile
    }
    var canDeleteProfile: Bool = true

    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UPCarouselFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
            if UIDevice.current.userInterfaceIdiom  == .pad{
                layout.itemSize = CGSize(width: collectionView.frame.width - 100, height: 120)
            }

            layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 120)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.scrollToCurrentPosition()
        }
    }
    fileprivate var items = characters
    
    fileprivate var currentPage: Int = 0
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate func scrollToCurrentPosition() {
        if currentPage > 0 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            let scrollPosition: UICollectionView.ScrollPosition = !orientation.isPortrait ? .centeredHorizontally : .centeredVertically
            self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
    
    @objc fileprivate func rotationDidChange() {
        guard !orientation.isFlat else { return }
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let direction: UICollectionView.ScrollDirection = orientation.isPortrait ? .horizontal : .vertical
        layout.scrollDirection = direction
        scrollToCurrentPosition()
    }
    
    override func viewLoaded() {
        super.viewLoaded()
        currentPage = 0
        if let profile = profile {
            currentPage = (Int(profile.profileImage) ?? 1) - 1
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ManageProfileViewModel.rotationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func checkValidation(profileNameTextField: UITextField){
        if let params = self.validateModelWith(profileNameTextField: profileNameTextField) {
            processData(params: params)
        }
    }
    
    func deleteProfileButtonTapped() {
        if let profile = profile {
            var profileDeleted: Bool = false
            let controller = DeleteProfileViewController.getController() as! DeleteProfileViewController
            controller.dismissCompletion = {
                if profileDeleted {
                    self.completionHandler?()
                    self.hostViewController.backButtonTapped(nil)
                }
            }
            controller.show(over: self.hostViewController, profile: profile) {
                profileDeleted = true
            }
        }
    }
}
extension ManageProfileViewModel{
    // MARK:-
    // MARK:- add validations
    private func validateModelWith(profileNameTextField: UITextField) -> [String: Any]? {
        let profileName = profileNameTextField.text?.trimmed ?? ""
        
        if profileName.isEmpty {
            profileNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyProfileName)
            return nil
        } else if profileName.count < 3 || profileName.count > 50 {
            profileNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidProfileName)
            return nil
        }
//        else if profileName.isValidProfileName == false {
//            profileNameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.validProfileName)
//            return nil
//        }
        var params = [String: Any]()
        params[WebConstants.profileName] = profileName
        params[WebConstants.profileImage] = "\(characters[currentPage].id)"
        params[WebConstants.id] = profile?._id
        return params
    }
    
}

extension ManageProfileViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        let character = items[indexPath.row]
        cell.image.image = character.image
        cell.imageBgView.layer.cornerRadius = cell.imageBgView.frame.size.width/2
//        cell.imageBgView.layer.borderWidth = 1
//        cell.imageBgView.layer.borderColor = UIColor.white.cgColor
        cell.imageBgView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let character = items[(indexPath as NSIndexPath).row]
//        let alert = UIAlertController(title: character.name, message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: 120, height: 120)
        }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
}

    
extension ManageProfileViewModel {
    
    func apiCallSuccess() {
        if profile == nil { // create new profile
            let newlyCreatedProfile = KUSERMODEL.user.profiles.last
            let controller = PreferenceViewController.getController() as! PreferenceViewController
            controller.clearNavigationStackOnAppear = true
            controller.isForCreateNewProfile = true
            controller.show(from: self.hostViewController, profile: newlyCreatedProfile) {
                self.completionHandler?()
            }
        } else {
            self.completionHandler?()
            self.hostViewController.backButtonTapped(nil)
        }
    }
    
    func processData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.profile,
                               params: params,
                               headers: headers,
                               method: profile == nil ? .post : .put) { response, _ in
            if !self.hasErrorIn(response) {
                let rawProfiles = response![APIConstants.data] as! [[String: Any]]
                KUSERMODEL.updateProfiles(rawProfiles)
                showSuccessMessage(with: self.profile == nil ? SucessMessage.createProfileSuccess : SucessMessage.editProfileSuccess)
                self.apiCallSuccess()
            }
            hideLoader()
        }
    }
}
