//
//  EditUserDetailViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit
import CountryPickerView
class EditUserDetailViewModel: BaseViewModel {
    var user = KUSERMODEL.user
    var completionHandler: ((Bool) -> Void)?
    lazy var countryCode: String = self.getCountryCode()
    var countryCodeUpated: (()->Void)?
    var needsEmailVerification: Bool = false
    
    private lazy var cpv: CountryPickerView = {
        let countryPickerView = CountryPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = hostViewController
        return countryPickerView
    }()
    
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
    
    @objc
    func selectCountryTapped() {
        self.showCountryPicker()
    }
    
    func showCountryPicker() {
        cpv.showCountriesList(from: hostViewController)
    }
    
    func checkValidation(fullNameTextField: UITextField,
                         emailTextField: UITextField,
                         phoneTextField: UITextField){
        if let params = self.validateModelWith(fullNameTextField: fullNameTextField,
                                               emailTextField: emailTextField,
                                               phoneTextField: phoneTextField) {
            processData(params: params)
        }
    }
    
    
    func proceedToEmailVerification(secondaryEmailForUpdate: String) {
        VerificationCodeVC.show(from: self.hostViewController, screenFlow: .editUserDetails, secondaryEmailForUpdate: secondaryEmailForUpdate) { success in
            self.user.email = secondaryEmailForUpdate
            KAPPSTORAGE.user = self.user
            if let vc = self.hostViewController.navigationController?.viewControllers.first(where: { $0 is UserAccountDetailViewController }) {
                self.hostViewController.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func detailsUpdated() {
        showSuccessMessage(with: SucessMessage.editProfileSuccess)
        self.hostViewController.backButtonTapped(nil)
    }
}

// MARK:-
// MARK:- add validations
extension EditUserDetailViewModel{
    
    func validateModelWith(fullNameTextField: UITextField,
                           emailTextField: UITextField,
                           phoneTextField: UITextField) -> [String: Any]? {
        
        let emailAddress = emailTextField.text?.trimmed ?? ""
        let fullName = fullNameTextField.text?.trimmed ?? ""
        let phone = (phoneTextField.text?.trimmed ?? "").replacingOccurrences(of: " ", with: "")
        
        if fullName.isEmpty {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyFullName)
            return nil
        }
        else if fullName.count < 1 || fullName.count > 50{
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
        var params = [String: Any]()
        if emailAddress != user.email {
            needsEmailVerification = true
            params[WebConstants.email] = emailAddress
        } else {
            needsEmailVerification = false
        }
        if fullName != user.fullName {
            params[WebConstants.name] = fullName
        }
        
        let numberAsInt = Int(phone)
        let backToString = "\(numberAsInt ?? 0)"
        print(backToString)
        
        if countryCode != user.countryCode || phone != user.phoneNumber.replacingOccurrences(of: " ", with: "") {
            
            params[WebConstants.phoneNumber] = countryCode + "-" + backToString
        }
        if phone.isEmpty {
            params[WebConstants.phoneNumber] = ""
        } else {
            params[WebConstants.phoneNumber] = self.countryCode + "-" + backToString.trimmed
        }
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        return params
    }
    
}

//MARK:- Country picker Delegate
extension EditUserDetailViewModel: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
        self.countryCode = country.phoneCode
        self.countryCodeUpated?()
    }
}


extension EditUserDetailViewModel {
    //MARK:- API Call...
    func processData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateUser,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.user.updateWith(responseData)
                                    UserModel.shared.setUserLoggedIn(true)
                                    if self.needsEmailVerification {
                                        self.proceedToEmailVerification(secondaryEmailForUpdate: params[WebConstants.email] as! String)
                                    } else {
                                        self.detailsUpdated()
                                    }
                                }
                                hideLoader()
        }
    }
}
