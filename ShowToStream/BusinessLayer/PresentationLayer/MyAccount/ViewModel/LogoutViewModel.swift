//
//  LogoutViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit

class LogoutViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    
    func logoutButtonTapped() {
        processData(params: [WebConstants.deviceToken: KAPPSTORAGE.fcmToken, WebConstants.deviceName: DEVICENAME])
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

extension LogoutViewModel {
    func processData(params: [String: Any]) {
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


