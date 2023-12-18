//
//  ChangePasswordViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import Foundation
import  UIKit
class ChangePasswordViewModel: BaseViewModel {
    
    var completionHandler: ((Bool) -> Void)?
    
    func forgotPasswrordButtonTapped(){
        ForgotPasswordViewController.show(from: self.hostViewController, forcePresent: false, isCome: StringConstants.changePassword) { success in
        }
    }
    
    func checkValidation(oldPasswordTextField: UITextField,
                         newPasswordTextField: UITextField,
                         confirmPasswordTextField: UITextField){
        if let params = self.validateModelWith(oldPasswordTextField: oldPasswordTextField,
                                               newPasswordTextField: newPasswordTextField,
                                               confirmPasswordTextField: confirmPasswordTextField) {
            processData(params: params)
        }
    }
    
    fileprivate func changePasswordSuccess() {
        showSuccessMessage(with: SucessMessage.changePasswordSuccess)
        //self.hostViewController.backButtonTapped(nil)
        self.logoutSuccess()
    }
    
    func logoutButtonTapped() {
        processDataForLogout(params: [WebConstants.deviceToken: KAPPSTORAGE.fcmToken, WebConstants.deviceName: DEVICENAME])
    }
    
    private func gotoLandingScreen(){
        KAPPDELEGATE.updateRootController(LandingViewController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }

    fileprivate func logoutSuccess() {
        KUSERMODEL.logoutUser()
        gotoLandingScreen()
    }
}
// MARK:-
// MARK:- add validations
extension ChangePasswordViewModel{
    
    private func validateModelWith(oldPasswordTextField: UITextField,
                           newPasswordTextField: UITextField,
                           confirmPasswordTextField: UITextField) -> [String: Any]? {
        
        let currentPassword = oldPasswordTextField.text ?? ""
        let newPassword = newPasswordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        if currentPassword.isEmpty {
            oldPasswordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyCurrentPassword)
            return nil
        }
        if newPassword.isEmpty {
            newPasswordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyNewPassword)
            return nil
        }
        else if newPassword.isValidPassword == false {
            newPasswordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPassword)
            return nil
        }
        else if newPassword.isValidPasswordWithSpecialChracter == false {
           newPasswordTextField.becomeFirstResponder()
           showMessage(with: ValidationError.invalidPasswordSpecial)
           return nil
       }
        else if currentPassword == newPassword {
            newPasswordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.sameNewPassword)
            return nil
        }
        
        if confirmPassword.isEmpty {
            confirmPasswordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyConfirmPassword)
            return nil
        } else if newPassword != confirmPassword {
            confirmPasswordTextField.becomeFirstResponder()
            showMessage(with: ValidationError.confirmPasswordMismatch)
            return nil
        }
        var params = [String: Any]()
        params[WebConstants.oldPassword] = currentPassword
        params[WebConstants.newPassword] = newPassword
        return params
    }
    
}

extension ChangePasswordViewModel {
    func processData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.changePassword,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    self.changePasswordSuccess()
                                }
                                hideLoader()
        }
    }
}


extension ChangePasswordViewModel {
    func processDataForLogout(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.logout,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    self.logoutSuccess()
                                }
                                hideLoader()
        }
    }
}


