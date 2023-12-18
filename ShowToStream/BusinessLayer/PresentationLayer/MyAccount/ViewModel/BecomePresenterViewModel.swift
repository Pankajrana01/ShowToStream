//
//  BecomePresenterViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 18/12/20.
//

import Foundation
import UIKit
import CountryPickerView
class BecomePresenterViewModel: BaseViewModel {
    var user = KUSERMODEL.user
    var completionHandler: ((Bool) -> Void)?
    var messageTextView = UITextView()
    lazy var countryCode: String = self.getCountryCode()
    var countryCodeUpated: (()->Void)?
    var commonUrls = [CommonUrl]()
    
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
    
    override func viewLoaded() {
        super.viewLoaded()
        
    }
    
    func openWebPage(titlename:String, url:String){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: titlename, url: url, iscomeFrom: ""){ status in
        }
    }
    
    func checkValidation(fullNameTextField: UITextField,
                         emailTextField: UITextField,
                         messageTextView: UITextView,
                         phoneTextField: UITextField,
                         companyNameTextField: UITextField){
        if let params = self.validateModelWith(fullNameTextField: fullNameTextField,
                                               emailTextField: emailTextField,
                                               messageTextView: messageTextView,
                                               phoneTextField: phoneTextField,
                                               companyNameTextField: companyNameTextField) {
            print(params)
            self.processData(params: params)
        }
    }
    
    func openSuccessMessageScreen(){
        SuccesScreenViewController.show(over: self.hostViewController) { status in
    }
        
        
        
//        let controller = SuccesScreenViewController.getController() as! SuccesScreenViewController
//        controller.dismissCompletion = { }
//        controller.show(over: self.hostViewController) { status in
//        }
    }
}
// MARK:-
// MARK:- add validations
extension BecomePresenterViewModel{
    
    func validateModelWith(fullNameTextField: UITextField,
                           emailTextField: UITextField,
                           messageTextView: UITextView,
                           phoneTextField: UITextField,
                           companyNameTextField: UITextField) -> [String: Any]? {
        let emailAddress = emailTextField.text?.trimmed ?? ""
        let message = messageTextView.text?.trimmed ?? ""
        let fullName = fullNameTextField.text?.trimmed ?? ""
        let phone = phoneTextField.text?.trimmed ?? ""
        let companyName = companyNameTextField.text?.trimmed ?? ""
        
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
        else if companyName.isEmpty {
            companyNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyCompanyName)
            return nil
        }
        else if companyName.count < 3 {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidCompanyName)
            return nil
        }
        else if companyName.count > 55 {
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidCompanyName)
            return nil
        }
        else if companyName.isValidName == false{
            fullNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.validCompanyName)
            return nil
        }
        else if message.isEmpty {
            messageTextView.becomeFirstResponder()
            showMessage(with: ValidationError.emptyMessage)
            return nil
        }
        else if message == StringConstants.briefAbout {
            messageTextView.becomeFirstResponder()
            showMessage(with: ValidationError.emptyMessage)
            return nil
        }
        var params = [String: Any]()
        params[WebConstants.name] = fullName
        params[WebConstants.email] = emailAddress
        let numberAsInt = Int(phone)
        let backToString = "\(numberAsInt!)"
        print(backToString)
        params[WebConstants.phoneNumber] = countryCode + "-" + backToString
        params[WebConstants.companyName] = companyName
        params[WebConstants.message] = message
        
        return params
    }
    
}


//MARK:- Country picker Delegate
extension BecomePresenterViewModel: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
        self.countryCode = country.phoneCode
        self.countryCodeUpated?()
        self.hostViewController.refreshUI()
    }
}

extension BecomePresenterViewModel {
    func processData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.becomeAPresenter,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if response?[APIConstants.status] as! Int == 400{
                                        showSuccessMessage(with: "\(response?[APIConstants.message] as? String ?? "")")
                                    }else{
                                        let responseData = response![APIConstants.data] as! [String:Any]
                                        if responseData[APIConstants.status] as! Int == 200{
                                           // showSuccessMessage(with: SucessMessage.becomePresenterSuccess)
                                            delay(2.0){
                                                self.openSuccessMessageScreen()
                                            }
                                        }
                                    }
                                }
                                hideLoader()
        }
    }
}
