//
//  LoginViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import CountryPickerView
class LoginViewModel: LoginBaseViewModel {
    
    var completionHandler: ((Bool) -> Void)?
    
    lazy var countryCode: String = self.getCountryCode()
    
    var countryCodeUpated: (()->Void)?
    
    var isNumericValue = false
    
    private lazy var cpv: CountryPickerView = {
        let countryPickerView = CountryPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = hostViewController
        return countryPickerView
    }()
    
    private func getCountryCode() -> String {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String,
            let code = cpv.getCountryByCode(countryCode)?.phoneCode {
            return code
        }
        else if let code = cpv.getCountryByPhoneCode(DefaultSelectedCountryCode)?.phoneCode {
            return code
        }
        return "N.A."
    }
    
    @objc
    func selectCountryTapped() {
        //cpv.defaultSelectedCountryCode = self.countryCode
        self.showCountryPicker()
    }
    
    func showCountryPicker() {
        cpv.showCountriesList(from: hostViewController)
    }
    override func loginButtonTapped() {
        showWorkInProgress()
    }

    func forgotPasswordButtonTapped() {
        ForgotPasswordViewController.show(from: self.hostViewController, forcePresent: false)
    }

    override func signupButtonTapped() {
        if let vc = self.hostViewController.navigationController?.viewControllers.first(where: { $0 is SignupViewController }) {
            self.hostViewController.navigationController?.popToViewController(vc, animated: true)
        } else {
            SignupViewController.show(from: hostViewController, forcePresent: true, autoEmbedInNavigationControllerIfPresent: true)
        }
    }
    
    func checkValidation(emailTextField: UITextField,
                         passwordTextField: UITextField){
        
        if isNumericValue == true{
            if let params = self.validateModelWithPhone(emailTextField: emailTextField,
                                                   passwordTextField: passwordTextField) {
                print(params)
                self.processData(params: params)
            }
        }else{
            if let params = self.validateModelWith(emailTextField: emailTextField,
                                                   passwordTextField: passwordTextField) {
                print(params)
                self.processData(params: params)
            }
        }
    }
    
    private func proceedToWhoWatching() {
        WhoWatchingViewController.show(from: hostViewController, forcePresent: true, autoEmbedInNavigationControllerIfPresent: true)
    }
    
    func sessionViewControllerOpen(){
       
    }
}
// MARK:-
// MARK:- add validations
extension LoginViewModel{
    
    func validateModelWith(emailTextField: UITextField,
                           passwordTextField: UITextField) -> [String: Any]? {
        
        let emailAddress = emailTextField.text?.trimmed ?? ""
        let password = passwordTextField.text?.trimmed ?? ""
        
        if emailAddress.isEmpty {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyEmail)
            return nil
        }
        else if emailAddress.isValidEmailAddress == false {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
        else if password.isEmpty {
            passwordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyPassword)
            return nil
        }
        else if password.isValidPassword == false {
            passwordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPassword)
            return nil
        }
        else if password.isValidPasswordWithSpecialChracter == false {
            passwordTextField.becomeFirstResponder()
           showMessage(with: ValidationError.invalidPasswordSpecial)
           return nil
       }
        params[WebConstants.emailOrPhoneNumber] = emailAddress
        params[WebConstants.password] = password
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        params[WebConstants.userCountry] = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        return params
    }
    
    func validateModelWithPhone(emailTextField: UITextField,
                           passwordTextField: UITextField) -> [String: Any]? {
        
        let phone = emailTextField.text?.trimmed ?? ""
        let password = passwordTextField.text?.trimmed ?? ""
        
        if phone.isEmpty {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPhoneNumber)
            return nil
        }
        else if phone.first == "0"{
//            if phone.isValidMobileNumberWithZero == false {
//                emailTextField.becomeFirstResponder()
//                showMessage(with: ValidationError.invalidPhoneNumberWithZero)
//                return nil
//            }
            showMessage(with: ValidationError.invalidPhoneNumberWithZeroStart)
            return nil
        }
        else if phone.isValidMobileNumber == false {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPhoneNumber)
            return nil
        }
        else if password.isEmpty {
            passwordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyPassword)
            return nil
        }
        else if password.isValidPassword == false {
            passwordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPassword)
            return nil
        }
        else if password.isValidPasswordWithSpecialChracter == false {
            passwordTextField.becomeFirstResponder()
           showMessage(with: ValidationError.invalidPasswordSpecial)
           return nil
       }
        let numberAsInt = Int(phone)
        let backToString = "\(numberAsInt!)"
        print(backToString)
        
        params[WebConstants.emailOrPhoneNumber] = self.countryCode + "-" + backToString.trimmed
        params[WebConstants.password] = password
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        params[WebConstants.userCountry] = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        return params
    }
    
}
//MARK:- Country picker Delegate
extension LoginViewModel: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
        self.countryCode = country.phoneCode
        self.countryCodeUpated?()
        self.hostViewController.refreshUI()
    }
}

extension LoginViewModel {
    func processData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.login,
                               params: params,
                               method: .put) { response, _ in
            
            if response![APIConstants.code] as? Int == 400{ // handle multiple sessions..
                if let responseData = response![APIConstants.data] as? [String: Any]{
                    if let sessionData = responseData[APIConstants.sessions] as? NSArray {
                        self.handleSessionsData(sessionsData: sessionData)
                        hideLoader()
                        return
                    }
                }
            }
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                self.user.loginType = self.loginType
                UserModel.shared.setUserLoggedIn(true)
    
                // to check either user verified email or empty phone number ...
//                if self.user.phoneNumber == ""{
//                    self.gotoCreateProfile(isCome: "", user: self.user)
//                }
                 if self.user.emailVerified == true {
                    self.takeUserToWhosWatching()
                }
                else{
                    self.proceedToEmailVerification()
                }
            }
            
            hideLoader()
        }
    }
    
    private func takeUserToWhosWatching() {
     KAPPDELEGATE.updateRootController(WhoWatchingViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func handleSessionsData(sessionsData:NSArray){
        self.sessions.removeAll()
        for i in 0..<sessionsData.count{
            self.sessions.append(Sessions(
                                    _id: (sessionsData[i] as AnyObject).value(forKey: WebConstants.id) as? String ?? "",
                                    deviceName: (sessionsData[i] as AnyObject).value(forKey: WebConstants.deviceName) as? String ?? "",
                                    deviceType: (sessionsData[i] as AnyObject).value(forKey: WebConstants.deviceType) as? String ?? ""))
        }
        
        self.proceedToSesssionScreen(session: sessions)
    }
    //MARK:- send to next screen...
    
    private func proceedToSesssionScreen(session:[Sessions]) {
        let controller = SessionViewController.getController() as! SessionViewController
        controller.dismissCompletion = {
            controller.dismiss()
        }
        controller.show(over: self.hostViewController, session: session) { id in
            print(id)
            controller.dismiss()
            self.params[WebConstants.sessionId] = id
            self.processData(params: self.params)
        }
    }
    
    private func proceedToEmailVerification() {
        VerificationCodeVC.show(from: self.hostViewController, screenFlow: .login) { success in
        }
    }
    private func gotoCreateProfile(isCome: String, user:User) {
        CreateProfileViewController.show(from: hostViewController, forcePresent: false, isCome: isCome, user: user, screenFlow: .login) { success in
            if success { }
        }
    }

    private func proceedToLandingScreen() {
        LandingViewController.show(from: hostViewController,forcePresent: false)
        
    }
}

