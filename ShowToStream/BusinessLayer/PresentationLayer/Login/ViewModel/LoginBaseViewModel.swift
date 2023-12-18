//
//  LoginBaseViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//


import UIKit

class LoginBaseViewModel: BaseViewModel {
    var sessions = [Sessions]()
    
    var params = [String: Any]()
    
    var loginType: LoginType = .email
    
    var screenState: LoginScreenState = .signUp
    
    var user = UserModel.shared.user
    
    
    @available(iOS 13.0, *)
    lazy var appleLoginModel = AppleLoginViewModel(hostViewController: hostViewController)
    
    lazy var faceboolLoginModel = FacebookLoginViewModel(hostViewController: hostViewController)
    
    lazy var googleLoginModel = GoogleLoginViewModel(hostViewController: hostViewController)

    func loginButtonTapped() { }

    func signupButtonTapped() { }
    
    func facebookButtonTapped() {
        loginType = .facebook
        faceboolLoginModel.login { user in
            if let user = user {
                self.apiCallForSocialLogin(with: user)
            }
        }
    }
    
    func appleButtonTapped() {
        if #available(iOS 13.0, *) {
            loginType = .apple
            appleLoginModel.login { user in
                self.apiCallForAppleSocialLogin(with: user)
            }
        }
    }
    
    func googleButtonTapped() {
        loginType = .google
        googleLoginModel.login { user in
            self.apiCallForSocialLogin(with: user)
        }
    }
}

extension LoginBaseViewModel {
    //MARK:- API Call...
    func apiCallForAppleSocialLogin(with user: User) {
        
        if !user.email.isEmpty {
            params[WebConstants.email] = user.email
        }
        if !user.fullName.isEmpty {
            params[WebConstants.name] = user.fullName
        } else {
            params[WebConstants.name] = "Apple"
        }

        params[WebConstants.userCountry] = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        params[WebConstants.socialId] = user.socialId
        params[WebConstants.oauthToken] = user.oauthToken
        params[WebConstants.loginType] = loginType.rawValue
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.socialLogin,
                               params: params,
                               method: .put) { response, _ in
            
            if response![APIConstants.code] as? Int == 400{ // handle multiple sessions..
                if let responseData = response![APIConstants.data] as? [String: Any]{
                    if let sessionData = responseData[APIConstants.sessions] as? NSArray {
                        self.handleSessionsData(sessionsData: sessionData)
                        hideLoader()
                        return
                    }
                }
            }
            if self.hasErrorIn(response) == false {
                self.user.updateWith(response![APIConstants.data] as! [String: Any])
                self.user.loginType = self.loginType
                KAPPSTORAGE.continueAsGuest = false
                UserModel.shared.setUserLoggedIn(true)
                
                // to check either user verified email or empty phone number ...
                if self.user.phoneNumber == ""{
                    self.gotoCreateProfile(isCome: StringConstants.social, user: self.user)
                } else {
                    self.takeUserToWhosWatching()
                }
//                else if self.user.emailVerified == true{
//                    self.takeUserToWhosWatching()
//                }
//                else{
//                    self.proceedToEmailVerification()
//                }
            }
            
            hideLoader()
        }
    }
    
    func apiCallForSocialLogin(with user: User) {
        
        if !user.email.isEmpty {
            params[WebConstants.email] = user.email
        }
        if !user.fullName.isEmpty {
            params[WebConstants.name] = user.fullName
        }

        params[WebConstants.userCountry] = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? ""
        params[WebConstants.socialId] = user.socialId
        params[WebConstants.oauthToken] = user.oauthToken
        params[WebConstants.loginType] = loginType.rawValue
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.socialLogin,
                               params: params,
                               method: .put) { response, _ in
            
            if response![APIConstants.code] as? Int == 400{ // handle multiple sessions..
                if let responseData = response![APIConstants.data] as? [String: Any]{
                    if let sessionData = responseData[APIConstants.sessions] as? NSArray {
                        self.handleSessionsData(sessionsData: sessionData)
                        hideLoader()
                        return
                    }
                }
            }
            
            if self.hasErrorIn(response) == false {
                self.user.updateWith(response![APIConstants.data] as! [String: Any])
                self.user.loginType = self.loginType
                KAPPSTORAGE.continueAsGuest = false
                UserModel.shared.setUserLoggedIn(true)
                
                // to check either user verified email or empty phone number ...
                if self.user.phoneNumber == ""{
                    self.gotoCreateProfile(isCome: StringConstants.social, user: self.user)
                }
                else if self.user.emailVerified == true{
                    self.takeUserToWhosWatching()
                }
                else{
                    self.proceedToEmailVerification()
                }
            }
            
            hideLoader()
        }
    }
    
    func processForSocialLogin() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.socialLogin,
                               params: params,
                               method: .put) { response, _ in
            
            if response![APIConstants.code] as? Int == 400{ // handle multiple sessions..
                if let responseData = response![APIConstants.data] as? [String: Any]{
                    if let sessionData = responseData[APIConstants.sessions] as? NSArray {
                        self.handleSessionsData(sessionsData: sessionData)
                        hideLoader()
                        return
                    }
                }
            }
            
            if self.hasErrorIn(response) == false {
                self.user.updateWith(response![APIConstants.data] as! [String: Any])
                self.user.loginType = self.loginType
                KAPPSTORAGE.continueAsGuest = false
                UserModel.shared.setUserLoggedIn(true)
                
                // to check either user verified email or empty phone number ...
                if self.user.phoneNumber == ""{
                    self.gotoCreateProfile(isCome: StringConstants.social, user: self.user)
                }
                else if self.user.emailVerified == true{
                    self.takeUserToWhosWatching()
                }
                else{
                    self.proceedToEmailVerification()
                }
            }
            
            hideLoader()
        }
    }
    
    fileprivate func proceedToEmailVerification() {
        VerificationCodeVC.show(from: self.hostViewController, screenFlow: .splash) { success in
        }
    }
    
   private func takeUserToWhosWatching() {
    KAPPDELEGATE.updateRootController(WhoWatchingViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
   }
    
   private func handleSessionsData(sessionsData:NSArray){
        self.sessions.removeAll()
        for i in 0..<sessionsData.count{
            self.sessions.append(Sessions(
                                    _id: (sessionsData[i] as AnyObject).value(forKey: WebConstants.id) as? String ?? "",
                                    deviceName: (sessionsData[i] as AnyObject).value(forKey: WebConstants.deviceName) as? String ?? "",
                                    deviceType: (sessionsData[i] as AnyObject).value(forKey: WebConstants.deviceType) as? String ?? ""))
        }
        
        self.proceedToSesssionScreen(session: sessions)
    }
    //MARK:- send to next screen...
    
    private func proceedToSesssionScreen(session:[Sessions]) {
        let controller = SessionViewController.getController() as! SessionViewController
        controller.dismissCompletion = {
            controller.dismiss()
        }
        controller.show(over: self.hostViewController, session: session) { id in
            print(id)
            controller.dismiss()
            self.params[WebConstants.sessionId] = id
            self.processForSocialLogin()
        }
    }
    //MARK:- send to next screen...
    private func gotoCreateProfile(isCome: String, user:User) {
        CreateProfileViewController.show(from: hostViewController, forcePresent: false, isCome: isCome, user: user, screenFlow: .login) { success in
            if success { }
        }
    }

    private func proceedToLandingScreen() {
        LandingViewController.show(from: hostViewController,forcePresent: false)
        
    }
}
