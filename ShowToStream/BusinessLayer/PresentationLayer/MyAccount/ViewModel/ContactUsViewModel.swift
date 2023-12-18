//
//  ContactUsViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 18/12/20.
//

import Foundation
import UIKit
import CountryPickerView
class ContactUsViewModel: BaseViewModel {
    var user = KUSERMODEL.user
    var completionHandler: ((Bool) -> Void)?
    var messageTextView = UITextView()
    var labelHeaderEmail: UILabel!
    var labelHeaderPhone: UILabel!
    
    lazy var countryCode: String = self.getCountryCode()
    var countryCodeUpated: (()->Void)?
    
    private lazy var cpv: CountryPickerView = {
        let countryPickerView = CountryPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = hostViewController
        return countryPickerView
    }()
    
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
    
    private func showCountryPicker() {
        cpv.showCountriesList(from: hostViewController)
    }
    
    override func viewLoaded() {
        super.viewLoaded()
        
    }
    
    func checkValidation(fullNameTextField: UITextField,
                         messageTextView: UITextView,
                         emailTextField: UITextField,
                         phoneTextField: UITextField){
        if let params = self.validateModelWith(fullNameTextField: fullNameTextField,
                                               messageTextView: messageTextView,
                                               emailTextField: emailTextField,
                                               phoneTextField: phoneTextField) {
            print(params)
            
            self.processData(params: params)
        }
    }
}
// MARK:-
// MARK:- add validations
extension ContactUsViewModel{
    
    private func validateModelWith(fullNameTextField: UITextField,
                           messageTextView: UITextView,
                           emailTextField: UITextField,
                           phoneTextField: UITextField) -> [String: Any]? {
        
        let message = messageTextView.text?.trimmed ?? ""
        let fullName = fullNameTextField.text?.trimmed ?? ""
        let email = emailTextField.text?.trimmed ?? ""
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
        } else if fullName.count > 50 {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidFullName)
            return nil
        }
//        else if fullName.isValidName == false{
//            fullNameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.validFullName)
//            return nil
//        }
        else if email.isEmpty {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyEmail)
            return nil
        }
        else if email.isValidEmailAddress == false {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
        else if phone.isEmpty {
            phoneTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPhoneNumber)
            return nil
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
        else if message.isEmpty {
            messageTextView.becomeFirstResponder()
            showMessage(with: ValidationError.emptyMessage)
            return nil
        }
        else if message == StringConstants.writehere {
            messageTextView.becomeFirstResponder()
            showMessage(with: ValidationError.emptyMessage)
            return nil
        }
        var params = [String: Any]()
        let numberAsInt = Int(phone)
        let backToString = "\(numberAsInt!)"
        print(backToString)
        params[WebConstants.name] = fullName
        params[WebConstants.phoneNumber] = countryCode + "-" + backToString
        params[WebConstants.message] = message
        params[WebConstants.email] = email
        return params
    }
    
}


//MARK:- Country picker Delegate
extension ContactUsViewModel: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
        self.countryCode = country.phoneCode
        self.countryCodeUpated?()
        self.hostViewController.refreshUI()
    }
}


extension ContactUsViewModel {
    //MARK:- API Call...
    func processData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.contact,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    if responseData[APIConstants.status] as! Int == 200{
                                        showSuccessMessage(with: SucessMessage.contactUsSuccess)
                                        self.hostViewController.backButtonTapped(nil)
                                    }
                                }
                                hideLoader()
        }
    }
}
