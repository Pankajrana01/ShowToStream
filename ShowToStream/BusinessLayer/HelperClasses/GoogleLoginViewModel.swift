//
//  GoogleLoginViewModel.swift
//  KarGoCustomer
//
//  Created by Applify on 24/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import GoogleSignIn
import UIKit

class GoogleLoginViewModel: BaseViewModel {
    var completionHandler: ((User) -> Void)?

    func login(completion: @escaping (_ user: User) -> Void) {
        self.completionHandler = completion
        GIDSignIn.sharedInstance()?.presentingViewController = self.hostViewController
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    class func logout(completion: @escaping (_ isSuccess: Bool) -> Void) {
        GIDSignIn.sharedInstance().signOut()
        completion(true)
    }
}

extension GoogleLoginViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn,
              didSignInFor user: GIDGoogleUser?,
              withError error: Error?) {
        
        DispatchQueue.main.async {
            if let error = error {
                if (error as NSError).code != -5 {
                    showMessage(with: error.localizedDescription)
                }
            } else if let user = user {
                let appUser = User()
                appUser.loginType = .google
                appUser.gmailId = user.userID
                appUser.fullName = user.profile.name
                appUser.firstName = user.profile.name.components(separatedBy: " ").first ?? ""
                appUser.lastName = user.profile.name.components(separatedBy: " ").last ?? ""
                appUser.email = user.profile.email
                appUser.oauthToken = user.authentication.idToken
                if let imageUrl = user.profile.imageURL(withDimension: 800) {
                    downloadImage(imageUrl) { localImageName in
                        appUser.profilePic = localImageName ?? ""
                        self.completionHandler?(appUser)
                    }
                } else {
                    self.completionHandler?(appUser)
                }
            } else {
                showMessage(with: GenericErrorMessages.internalServerError)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn,
              didDisconnectWith user: GIDGoogleUser?,
              withError error: Error?) {
    }

}
