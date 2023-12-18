//
//  VerifyShowViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 10/03/21.
//

import Foundation
class VerifyShowViewModel: BaseViewModel {
    let user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    var secondaryEmailForUpdate: String?
    var screenFlow: PNVSceenFlow!
    var otpType: PNVOtpType = .sms
    var showId: String?
    var completionHandler: ((Bool) -> Void)?
    var url = ""

    private func apiSuccess() {
        completionHandler?(true)
    }
    override func viewLoaded() {
        super.viewLoaded()
    }
    
    func gotoLoginScreen(){
        KAPPDELEGATE.updateRootController(LoginViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
    
    //MARK : to fill otp ...
    func otpFilled(otpText: String) {
        if let params = self.validateModelWith(otpTextField: otpText) {
            self.processDataforVerifyOtp(params: params)
        }
    }
   

    func openPaymentWebPage(title:String, url:String){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: title, url: url, iscomeFrom: ""){ status in
        }
    }
}

//MARK :
//MARK : add validation ...
extension VerifyShowViewModel { // validations
    func validateModelWith(otpTextField: String) -> [String: Any]? {
        let otp = otpTextField
        if otp.count == 0{
            showMessage(with: ValidationError.emptyCode)
            return nil
        }
        else if otp.count < 6 {
            showMessage(with: ValidationError.invalidCode)
            return nil
        }
        var params = [String: Any]()
        params[WebConstants.danceStudioCode] = otp
        params[WebConstants.id] = showId
        return params
        
    }
}

extension VerifyShowViewModel {
    //MARK:- API Call...
    private func processDataforVerifyOtp(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.danceDetails,
                               params: params,
                               headers: headers,
                               method: .post) { response, _  in
                                if !self.hasErrorIn(response) {
                                    //let responseData = response![APIConstants.data] as! [String: Any]
                                    //self.user.updateWith(responseData)
                                    showSuccessMessage(with: SucessMessage.codeVerificationSuccess)
//                                    self.hostViewController.backButtonTapped(nil)
                                    self.openPaymentWebPage(title: "Payment", url: self.url)
                                }
                                hideLoader()
        }
    }
  
   
}
