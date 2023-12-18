//
//  CreateProfileViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 31/12/20.
//

import UIKit

class CreateProfileViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.createProfile
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isCome:String,
                    user:User!,
                    screenFlow: PNVSceenFlow,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! CreateProfileViewController
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.isCome = isCome
        controller.viewModel.user = user
        controller.viewModel.screenFlow = screenFlow
        controller.viewModel.completionHandler = completionHandler
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    lazy var viewModel: CreateProfileViewModel = CreateProfileViewModel(hostViewController: self)

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var fullNameTextFileld: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButtonBottomConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        // Do any additional setup after loading the view.
        self.phoneNumberTextField.addLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                           target: self.viewModel,
                                           selector: #selector(EditUserDetailViewModel.selectCountryTapped))

        self.viewModel.countryCodeUpated = {
            self.phoneNumberTextField.addLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                                    target: self.viewModel,
                                                    selector: #selector(self.viewModel.selectCountryTapped))
        }
        self.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: StringConstants.phoneNumberPlaceholder,
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.appGray, NSAttributedString.Key.font: UIFont.appLightFont(with: 16)])
        passwordTextField.addRightButton(image: #imageLiteral(resourceName: "ic_eye_close"), tintColor: .white, target: self, selector: #selector(togglePasswordTapped(_:)))
        
        self.refershUI()
      
    }
    
    func refershUI(){
        // to check either social signup or email ...
        if viewModel.isCome == StringConstants.social{
            self.passwordTextField.isHidden = true
            self.fullNameTextFileld.text = self.viewModel.user.fullName
            if self.viewModel.user.email != "" {
                self.emailTextField.text = self.viewModel.user.email
                self.emailTextField.isUserInteractionEnabled = false
            }else{
                self.emailTextField.text = ""
                self.emailTextField.isUserInteractionEnabled = true
            }
        }
        else if viewModel.isCome == StringConstants.splash{
            self.passwordTextField.isHidden = false
            self.emailTextField.isUserInteractionEnabled = true
            self.fullNameTextFileld.text = self.viewModel.user.fullName
            self.emailTextField.text = self.viewModel.user.email
            let phNumber = viewModel.user.phoneNumber.replacingOccurrences(of: " ", with: "")
            phoneNumberTextField.text = phNumber.replacingOccurrences(of: self.viewModel.countryCode, with: "")
            //self.phoneNumberTextField.text = self.viewModel.user.phoneNumber
            self.passwordTextField.text = self.viewModel.user.password
        }
        else{
            self.passwordTextField.isHidden = false
            self.emailTextField.isUserInteractionEnabled = true
        }
    }

    @objc
    func togglePasswordTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.setImage(passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "ic_eye_close") : #imageLiteral(resourceName: "ic_eye_open"), for: .normal)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if viewModel.screenFlow == .splash {
            self.viewModel.gotoLoginScreen()
        }else{
            self.backButtonTapped(sender)
        }
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        self.viewModel.checkValidation(fullNameTextField: fullNameTextFileld, emailTextField: emailTextField, phoneTextField: phoneNumberTextField, passwordTextField: passwordTextField)
    }
    
}
extension CreateProfileViewController: UITextFieldDelegate {
    
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
//        if textField == phoneNumberTextField {
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
 
