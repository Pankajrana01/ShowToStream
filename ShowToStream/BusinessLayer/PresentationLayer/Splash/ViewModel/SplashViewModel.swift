//
//  SplashViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class SplashViewModel: BaseViewModel {
    
    var sessionCreated: Bool = false
    
    var user = UserModel.shared.user
    
    override func viewLoaded() {
        super.viewLoaded()
        sessionCreated = KUSERMODEL.isLoggedIn()
    }
    fileprivate func takeUserToLanding() {
        KAPPDELEGATE.updateRootController(LandingViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }

    fileprivate func takeUserToWhosWatching() {
        KAPPDELEGATE.updateRootController(WhoWatchingViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    fileprivate func proceedToEmailVerification() {
        VerificationCodeVC.show(from: self.hostViewController, screenFlow: .splash) { success in
        }
    }
    
    func proceedToWalkthrough() {
        delay(1) {
            KAPPDELEGATE.updateRootController(WalkthroughViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
        }
    }
    
    fileprivate func gotoCreateProfile(isCome: String, user:User) {
        CreateProfileViewController.show(from: hostViewController, forcePresent: false, isCome: isCome, user: user, screenFlow: .splash) { success in
            if success { }
        }
    }

    func proceedToNextScreen() {
        if sessionCreated {
            updateUserDetails()
            processCurrencyData()
        } else if KAPPSTORAGE.hasSetPreferences { // not logged in, but has chosen preferences locally, so he will be redirected to landing screen on next app run.
            takeUserToLanding()
        } else {
            proceedToWalkthrough()
        }
    }
    
    func updateUserDetails(){
        var params = [String: Any]()
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        self.processData(params: params)
    }
    
}


extension SplashViewModel {
    func processData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in 
            
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                UserModel.shared.setUserLoggedIn(true)
            // to check phone number is added or not ...
                    if self.user.phoneNumber == "" { // will consider social login case where phone number is nill ...
                        self.gotoCreateProfile(isCome: StringConstants.social, user: self.user)
                    } else if self.user.emailVerified == true { // to check either user verified email or not ...
                        // will handle navigation to "Who's watching" screen when session is created.
                        self.takeUserToWhosWatching()
                    } else {
                        //self.proceedToEmailVerification()
                        self.gotoCreateProfile(isCome: StringConstants.splash, user: self.user)
                    }
                
            }
            hideLoader()
        }
    }
    
    func processCurrencyData() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.Profile.currency,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .post) { response, _ in
            
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                print(self.user.currencyType, self.user.currencyRate)
            }
            hideLoader()
        }
    }
}
