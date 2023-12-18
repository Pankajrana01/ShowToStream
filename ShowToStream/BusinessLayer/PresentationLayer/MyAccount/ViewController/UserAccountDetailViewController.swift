//
//  UserAccountViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit

class UserAccountDetailViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.userDetailAccount
    }
    
    override func show(from viewController: UIViewController,
                       forcePresent: Bool = true) {
        self.modalPresentationStyle = .fullScreen
        if forcePresent {
            viewController.present(self,
                                   animated: false,
                                   completion: nil)
        } else {
            viewController.show(self,
                                sender: nil)
        }
    }
    
    @IBOutlet private weak var fullNameTextField: ShowToStreamTextField!
    @IBOutlet private weak var emailTextField: ShowToStreamTextField!
    @IBOutlet private weak var mobileNumberTextField: ShowToStreamTextField!
    @IBOutlet private weak var changePasswordView: UIView!
    
    lazy var viewModel: UserAccountDetailModel = UserAccountDetailModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    override func refreshUI() {
        super.refreshUI()
        fullNameTextField.text = viewModel.user.fullName
        emailTextField.text = viewModel.user.email
        if viewModel.user.countryCode == viewModel.user.phoneNumber {
            mobileNumberTextField.text = viewModel.user.countryCode
        } else {
            mobileNumberTextField.text = viewModel.user.countryCode + " " + viewModel.user.phoneNumber
        }
        
        
        if viewModel.user.loginType == .email{
            self.changePasswordView.isHidden = false
        }else{
            self.changePasswordView.isHidden = true
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
    
    @IBAction func editUserDetailButton(_ sender: UIButton) {
        viewModel.editAccountButtonTapped()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        viewModel.logoutButtonTapped()
    }
    
    @IBAction func changePasswordButton(_ sender: UIButton) {
        viewModel.changePasswordButtonTapped()
    }
}
