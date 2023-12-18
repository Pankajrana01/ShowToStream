//
//  ManageProfileViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 21/12/20.
//

import UIKit

class ManageProfileViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.manageProfile
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = true,
                    profile: Profile? = nil,
                    canDeleteProfile: Bool,
                    completionHandler: @escaping () -> Void) {
        let controller = self.getController() as! ManageProfileViewController
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.profile = profile
        controller.viewModel.canDeleteProfile = canDeleteProfile
        controller.viewModel.completionHandler = completionHandler
        
        let navVC = UINavigationController(rootViewController: controller)
        navVC.setNavigationBarHidden(true, animated: false)
        navVC.modalPresentationStyle = .fullScreen
        viewController.present(navVC, animated: true, completion: nil)
    }
    
    lazy var viewModel: ManageProfileViewModel = ManageProfileViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var Titlelabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var createProfileButton: UIButton!
    @IBOutlet private weak var profileNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        
        self.viewModel.collectionView = collectionView
        self.Titlelabel.text = self.viewModel.titleName
        profileNameTextField.text = self.viewModel.profile?.profileName
        if self.viewModel.titleName == StringConstants.newProfile {
            self.deleteButton.isHidden = true
            self.createProfileButton.setTitle(StringConstants.createProfile, for: .normal)
        }else{
            self.createProfileButton.setTitle(StringConstants.updateProfile, for: .normal)
        }
        if !viewModel.canDeleteProfile {
            self.deleteButton.isHidden = true
        }
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
    
    @IBAction func deleteProfileButton(_ sender: UIButton) {
        self.viewModel.deleteProfileButtonTapped()
    }
    
    @IBAction func createProfileButton(_ sender: UIButton) {
        self.viewModel.checkValidation(profileNameTextField: profileNameTextField)
    }
}
