//
//  CreateProfileViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 31/12/20.
//

import Foundation
import UIKit
import CountryPickerView
class CreateProfileViewModel: BaseViewModel {
    
    var isCome = ""
    
    var completionHandler: ((Bool) -> Void)?
    
    lazy var countryCode: String = self.getCountryCode()
    
    var countryCodeUpated: (()->Void)?
    
    var user = UserModel.shared.user
    
    var screenFlow: PNVSceenFlow!
    
    private lazy var cpv: CountryPickerView = {
        let countryPickerView = CountryPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = hostViewController
        return countryPickerView
    }()
    
//    private func getCountryCode() -> String {
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String,
//            let code = cpv.getCountryByCode(countryCode)?.phoneCode {
//            return code
//        }
//        else if let code = cpv.getCountryByPhoneCode(DefaultSelectedCountryCode)?.phoneCode {
//            return code
//        }
//        return "N.A."
//    }
    //MARK:- country code check
    private func getCountryCode() -> String {
        if let code = cpv.getCountryByPhoneCode(user.countryCode)?.phoneCode {
            return code
        } else if let code = cpv.getCountryByPhoneCode(DefaultSelectedCountryCode)?.phoneCode {
            return code
        } else if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String,
            let code = cpv.getCountryByCode(countryCode)?.phoneCode {
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
    
    func checkValidation(fullNameTextField: UITextField,
                         emailTextField: UITextField,
                         phoneTextField: UITextField,
                         passwordTextField: UITextField){
        // to check either social signup or email ...
        if isCome == StringConstants.social{
            if let params = self.validateModelWithoutPassword(fullNameTextField: fullNameTextField,
                                                   emailTextField: emailTextField,
                                                   phoneTextField: phoneTextField) {
                print(params)
                self.processDataForUpdateUser(params: params)
            }
        }else{
            if let params = self.validateModelWith(fullNameTextField: fullNameTextField,
                                                   emailTextField: emailTextField,
                                                   phoneTextField: phoneTextField,
                                                   passwordTextField: passwordTextField) {
                print(params)
                self.processData(params: params)
               
            }
        }
    }
    
    func proceedToEmailVerification() {
        VerificationCodeVC.show(from: self.hostViewController, screenFlow: .signup) { success in
        }
    }
    
    func proceedNextLandingScreen() {
        let controller = LandingViewController.getController()
        controller.clearNavigationStackOnAppear = true
        controller.show(from: self.hostViewController)
    }
    
    func syncPreferences() {
        var selecedCategoryIds = [String]()
        KAPPSTORAGE.categories.forEach( { selecedCategoryIds.append($0._id) } )

        var selecedGenreIds = [String]()
        KAPPSTORAGE.genres.forEach( { selecedGenreIds.append($0._id) } )
        let params: [String: Any] = [WebConstants.categoryIds: selecedCategoryIds,
                                     WebConstants.genreIds: selecedGenreIds,
                                     WebConstants.profileId: KUSERMODEL.selectedProfile._id!]
        processDataForSyncPreferences(params: params)

    }
    
    func gotoLoginScreen(){
        UserModel.shared.logoutUser()
        KAPPDELEGATE.updateRootController(LoginViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
}
// MARK:-
// MARK:- add validations
extension CreateProfileViewModel{
    
    func validateModelWith(fullNameTextField: UITextField,
                           emailTextField: UITextField,
                           phoneTextField: UITextField,
                           passwordTextField: UITextField) -> [String: Any]? {
        
        let emailAddress = emailTextField.text?.trimmed ?? ""
        let fullName = fullNameTextField.text?.trimmed ?? ""
        let phone = phoneTextField.text?.trimmed ?? ""
        let password = passwordTextField.text?.trimmed ?? ""
        
        if fullName.isEmpty {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyFullName)
            return nil
        }
        else if fullName.count < 1 {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidFullName)
            return nil
        }
        else if fullName.count > 50 {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidFullName)
            return nil
        }
//        else if fullName.isValidName == false{
//            fullNameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.validFullName)
//            return nil
//        }
        else if emailAddress.isEmpty {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyEmail)
            return nil
        }
        else if emailAddress.isValidEmailAddress == false {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
        else if phone.isEmpty {
//            phoneTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.invalidPhoneNumber)
//            return nil
        }
        else if phone.first == "0"{
//            if phone.isValidMobileNumberWithZero == false {
//                phoneTextField.becomeFirstResponder()
//                showMessage(with: ValidationError.invalidPhoneNumberWithZero)
//                return nil
//            }
            showMessage(with: ValidationError.invalidPhoneNumberWithZeroStart)
            return nil
        }
        else if phone.isValidMobileNumber == false {
            phoneTextField.becomeFirstResponder()
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
        var params = [String: Any]()
        params[WebConstants.email] = emailAddress
        params[WebConstants.password] = password
        params[WebConstants.name] = fullName
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        
        let numberAsInt = Int(phone)
        let backToString = "\(numberAsInt ?? 0)"
        print(backToString)
        //05-05-2022
        if phone.isEmpty {
            params[WebConstants.phoneNumber] = ""
        } else {
            params[WebConstants.phoneNumber] = self.countryCode + "-" + backToString.trimmed
        }
       
        params[WebConstants.deviceName] = DEVICENAME
        params[WebConstants.userCountry] = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        return params
    }
    
    func validateModelWithoutPassword(fullNameTextField: UITextField,
                           emailTextField: UITextField,
                           phoneTextField: UITextField) -> [String: Any]? {
        
        let emailAddress = emailTextField.text?.trimmed ?? ""
        let fullName = fullNameTextField.text?.trimmed ?? ""
        let phone = phoneTextField.text?.trimmed ?? ""
        
        if fullName.isEmpty {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyFullName)
            return nil
        }
        else if fullName.count < 1 {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidFullName)
            return nil
        }
//        else if fullName.isValidName == false{
//            fullNameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.validFullName)
//            return nil
//        }
        else if emailAddress.isEmpty {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyEmail)
            return nil
        }
        else if emailAddress.isValidEmailAddress == false {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
//        else if phone.isEmpty {
//            phoneTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.invalidPhoneNumber)
//            return nil
//        }
//        else if phone.isValidMobileNumber == false {
//            phoneTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.invalidPhoneNumber)
//            return nil
//        }
        
        var params = [String: Any]()
        params[WebConstants.email] = emailAddress
        params[WebConstants.name] = fullName
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
//        params[WebConstants.type] = WebConstants.user
        if phone.isEmpty == false{
            let numberAsInt = Int(phone)
            let backToString = "\(numberAsInt!)"
            print(backToString)
            
            params[WebConstants.phoneNumber] = self.countryCode + "-" + backToString
        } else {
            params[WebConstants.phoneNumber] = ""//self.countryCode
        }
        params[WebConstants.deviceName] = DEVICENAME
        return params
    }
    
}
//MARK:- Country picker Delegate
extension CreateProfileViewModel: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
        self.countryCode = country.phoneCode
        self.countryCodeUpated?()
        self.hostViewController.refreshUI()
    }
}


extension CreateProfileViewModel {
    //MARK:- API Call...
    func processData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.register,
                               params: params,
                               headers: nil,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.user.updateWith(responseData)
//                                    KUSERMODEL.setUserLoggedIn(true)
                                    KUSERMODEL.selectedProfileIndex = 0
                                    self.syncPreferences()
                                }
                                hideLoader()
        }
    }
    
    func processDataForUpdateUser(params: [String: Any]) {
        showLoader()
        
        ApiManager.makeApiCall(APIUrl.UserApis.updateUser,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                    KUSERMODEL.selectedProfileIndex = 0
                                    self.syncPreferences()
                                }
                                hideLoader()
        }
    }
    
    
    func processDataForSyncPreferences(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.preferences,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let rawProfiles = response![APIConstants.data] as! [[String: Any]]
                                    
                                    KUSERMODEL.updateProfiles(rawProfiles)
                                    
                                    // to check for social login...
                                    if self.isCome == StringConstants.social{
                                        if self.user.email != "" { // if user email fetch then no need to verify email then proceed for landing screen
                                            self.proceedNextLandingScreen()
                                        }else{
                                            self.proceedToEmailVerification() // if user email is not fetch then need to verify email then proceed for landing screen
                                        }
                                    }else{
                                        self.proceedToEmailVerification() //for email login need to verify email then proceed for landing screen. 
                                    }
                                }
                                hideLoader()
        }
    }

}
