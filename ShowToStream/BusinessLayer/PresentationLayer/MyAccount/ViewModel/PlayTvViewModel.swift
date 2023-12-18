//
//  PlayTvViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 22/12/20.
//

import Foundation
import UIKit
class PlayTvViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?

    //MARK :
    //MARK : to fill otp ...
    func otpFilled(otpText: String) {
        if let params = self.validateModelWith(otpTextField: otpText) {
            print(params)
            processData(params: params)
        }
    }
    
    func validateModelWith(otpTextField: String) -> [String: Any]? {
        let otp = otpTextField
        if otp.count < 4 {
            showMessage(with: ValidationError.invalidOtp)
            return nil
        }
        var params = [String: Any]()
        params[WebConstants.tvCode] = "\(otp)"
        return params
        
    }
}

extension PlayTvViewModel{
    func processData(params:[String:Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.playOnTV,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String:Any]
                                    if responseData[APIConstants.status] as! Int == 200{
                                        showSuccessMessage(with: SucessMessage.playTvSuccess)
                                        self.hostViewController.backButtonTapped(nil)
                                    }
                                }
            hideLoader()
        }
    }
}
