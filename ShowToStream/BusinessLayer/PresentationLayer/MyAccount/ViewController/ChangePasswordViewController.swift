//
//  ChangePasswordViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.changePassword
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
    
    lazy var viewModel: ChangePasswordViewModel = ChangePasswordViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    @IBOutlet private weak var oldPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        viewModel.forgotPasswrordButtonTapped()
    }
    
    @IBAction func changePasswordButton(_ sender: UIButton) {
        viewModel.checkValidation(oldPasswordTextField: oldPasswordTextField, newPasswordTextField: newPasswordTextField, confirmPasswordTextField: confirmPasswordTextField)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
}
extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextTF = textField.superview?.viewWithTag(nextTag) as UIResponder?
        if nextTF != nil {
            nextTF?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
