//
//  ForgotPasswordViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 18/12/20.
//

import Foundation
import UIKit
class ForgotPasswordViewModel: BaseViewModel {
    
    var completionHandler: ((Bool) -> Void)?
    
    var email = ""
    
    var isCome = ""
    
    func checkValidation(emailTextField: UITextField){
        if let params = self.validateModelWith(emailTextField: emailTextField) {
            print(params)
            self.email = emailTextField.text!
            self.processData(params: params)
        }
    }
    
    func proceedToResetScreen(waitingTime:Int){
        ResetPasswordViewController.show(from: self.hostViewController, forcePresent: false, email: self.email, isCome: isCome, waitingTime: waitingTime) { success in
        }
    }
}

extension ForgotPasswordViewModel{ // validations
    
    func validateModelWith(emailTextField: UITextField) -> [String: Any]? {
        let emailAddress = emailTextField.text?.trimmed ?? ""
        if emailAddress.isEmpty {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyEmail)
            return nil
        } else if emailAddress.isValidEmailAddress == false {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
        var params = [String: Any]()
        params[WebConstants.emailOrPhoneNumber] = emailAddress
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        params[WebConstants.platform] = Platform.iOS.rawValue
        return params
    }
    
}

extension ForgotPasswordViewModel {
    func processData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.forgotPassword,
                               params: params,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    showSuccessMessage(with: SucessMessage.forgotSuccess)
                                    
                                    if let nextWaitingTime = (response![APIConstants.data] as! [String: Any])[WebConstants.waitingInterval] as? Int{
                                        self.proceedToResetScreen(waitingTime: nextWaitingTime)
                                        
                                    }
                                    
                                }
                                hideLoader()
        }
    }
}
