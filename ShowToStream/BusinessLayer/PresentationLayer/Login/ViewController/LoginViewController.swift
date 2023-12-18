//
//  LoginViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class LoginViewController: LoginBaseViewController {
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.login
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController, forcePresent: Bool = true, autoEmbedInNavigationControllerIfPresent: Bool = true) {
        (self.getController() as! LoginViewController).show(from: viewController, forcePresent: forcePresent, autoEmbedInNavigationControllerIfPresent: autoEmbedInNavigationControllerIfPresent)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = true, autoEmbedInNavigationControllerIfPresent: Bool = true) {
        if forcePresent, autoEmbedInNavigationControllerIfPresent {
            let navigationVC = UINavigationController(rootViewController: self)
            navigationVC.isNavigationBarHidden = true
            navigationVC.modalPresentationStyle = .fullScreen
            viewController.present(navigationVC, animated: true, completion: nil)
        } else {
            self.show(from: viewController, forcePresent: forcePresent)
        }
    }

    lazy var viewModel = LoginViewModel(hostViewController: self)
   
    @IBOutlet private weak var emailTextField: LMDFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        
        passwordTextField.addRightButton(image: #imageLiteral(resourceName: "ic_eye_close"), tintColor: .white, target: self, selector: #selector(togglePasswordTapped(_:)))
        
        let udid = UIDevice.current.identifierForVendor?.uuidString
                  let name = UIDevice.current.name
                  let version = UIDevice.current.systemVersion
                  let modelName = UIDevice.current.model
                  print(udid ?? "")    // D774EAE3F447445F9D5FE2B3B699ADB1
                  print(name)          // iPhone XR
                  print(version)       // 12.1
                  print(modelName)
    }

    @objc
    func togglePasswordTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.setImage(passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "ic_eye_close") : #imageLiteral(resourceName: "ic_eye_open"), for: .normal)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any?) {
        self.viewModel.forgotPasswordButtonTapped()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.viewModel.checkValidation(emailTextField: emailTextField, passwordTextField: passwordTextField
        )
    }
    
    @IBAction func SignupButton(_ sender: UIButton) {
        self.viewModel.signupButtonTapped()
    }
    
}

extension LoginViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.emailTextField{
            if string.isNumericValue == true{
                if textField.text?.isValidEmailAddress == true {
                    self.viewModel.isNumericValue = false
                }else{
                    self.viewModel.isNumericValue = true
                }
                print("numbric")
                if range.location == 0{
                    DispatchQueue.main.async {
                        self.emailTextField.addNewLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                                             target: self.viewModel,
                                                             selector: #selector(LoginViewModel.selectCountryTapped))
                    }
                    self.viewModel.countryCodeUpated = {
                        self.emailTextField.addNewLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                                             target: self.viewModel,
                                                             selector: #selector(self.viewModel.selectCountryTapped))
                    }
                    
                    self.emailTextField.left_Padding = 80
                    self.emailTextField.leftPadding = 80
                }
            }else if string.isAlphabetValue{
                self.viewModel.isNumericValue = false
                if range.location == 0 {
                    self.emailTextField.left_Padding = 14.0
                    self.emailTextField.leftPadding = 0
                    DispatchQueue.main.async {
                        self.emailTextField.addLeftButton(accessories: [],
                                                          target: nil,
                                                          selector: nil)
                    }
                }
                
            }else{
                print("nothing")
            }
        }
        return true
    }
}
