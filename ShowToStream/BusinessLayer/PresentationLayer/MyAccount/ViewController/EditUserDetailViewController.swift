//
//  EditUserDetailViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit

class EditUserDetailViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.editUserDetailAccount
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
    
    lazy var viewModel: EditUserDetailViewModel = EditUserDetailViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        self.phoneTextField.addLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                           target: self.viewModel,
                                           selector: #selector(EditUserDetailViewModel.selectCountryTapped))

        self.viewModel.countryCodeUpated = {
            self.phoneTextField.addLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                                    target: self.viewModel,
                                                    selector: #selector(self.viewModel.selectCountryTapped))
            
        }
        self.phoneTextField.attributedPlaceholder = NSAttributedString(string: StringConstants.phoneNumberPlaceholder,
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.appGray, NSAttributedString.Key.font: UIFont.appLightFont(with: 16)])
        refreshUI()
    }
    
    override func refreshUI() {
        super.refreshUI()
        fullNameTextField.text = viewModel.user.fullName
        emailTextField.text = viewModel.user.email
        phoneTextField.text = viewModel.user.phoneNumber.replacingOccurrences(of: " ", with: "")
        if viewModel.user.loginType == .email{
            emailTextField.isUserInteractionEnabled = true
        }else{
            emailTextField.isUserInteractionEnabled = false
        }
    }

    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        viewModel.checkValidation(fullNameTextField: fullNameTextField, emailTextField: emailTextField, phoneTextField: phoneTextField)
    }
    
}

extension EditUserDetailViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if viewModel.user.loginType == .email{
            let nextTag = textField.tag + 1
            let nextTF = textField.superview?.viewWithTag(nextTag) as UIResponder?
            if nextTF != nil {
                nextTF?.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        else{
            let nextTag = textField.tag + 2
            let nextTF = textField.superview?.viewWithTag(nextTag) as UIResponder?
            if nextTF != nil {
                nextTF?.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return false
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == phoneTextField {
//            if range.length > 0 {
//                return true
//            }
//            if string == "" {
//                return false
//            }
//            if range.location > 17 {
//                return false
//            }
//            var originalText = textField.text
//            let replacementText = string.replacingOccurrences(of: " ", with: "")
//            
//            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
//                return false
//            }
//            
//            if range.location == 3 || range.location == 7 {
//                originalText?.append(" ")
//                textField.text = originalText
//            }
//            return true
//        }
//        return true
//    }
}
