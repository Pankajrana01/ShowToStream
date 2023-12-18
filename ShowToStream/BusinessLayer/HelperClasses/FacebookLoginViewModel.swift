//
//  FacebookLoginViewModel.swift
//  KarGoCustomer
//
//  Created by Applify on 23/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import FBSDKLoginKit
import UIKit

class FacebookLoginViewModel: BaseViewModel {
    
    func login(completion: @escaping (_ user: User?) -> Void) {
        let loginManager = LoginManager()
        let params = ["public_profile", "email"]
        loginManager.logIn(permissions: params, from: hostViewController) { result, error in
            if let result = result {
                if result.isCancelled {
                    completion(nil)
                } else if result.grantedPermissions.contains("public_profile") ||
                    result.grantedPermissions.contains("email") {
                    DispatchQueue.main.async {
                        showLoader()
                        let params = ["fields": "name, email, picture.width(800).height(800)"]
                        let graphRequest = GraphRequest(graphPath: "me",
                                                        parameters: params)
                        graphRequest.start(completionHandler: { connection, result, error -> Void in
                            if error != nil {
                                completion(nil)
                            } else if let result = result as? [String: Any],
                                let socialId = result["id"] as? String {
                                let user = User()
                                user.loginType = .facebook
                                user.oauthToken = AccessToken.current?.tokenString ?? ""
                                let emailAddress = result["email"] as? String ?? ""
                                let name = result["name"] as? String ?? ""
                                user.fullName = name
                                user.facebookId = socialId
                                user.firstName = name.components(separatedBy: " ").first ?? ""
                                user.lastName = name.components(separatedBy: " ").last ?? ""
                                user.email = emailAddress
                                let pictures = (result["picture"] as? [String: Any])
                                let profilePicUrl = (pictures?["data"] as? [String: Any])?["url"] as? String
                                
                                if let profilePicUrl = URL(string: profilePicUrl ?? "") {
                                    downloadImage(profilePicUrl) { localImageName in
                                        hideLoader()
                                        user.profilePic = localImageName ?? ""
                                        completion(user)
                                    }
                                } else {
                                    hideLoader()
                                    completion(user)
                                }
                            }
                        })
                    }
                } else {
                    completion(nil)
                }
            } else {
                showMessage(with: GenericErrorMessages.internalServerError)
                completion(nil)
            }
        }
    }
    
    class func logout(completion: @escaping (_ isSuccess: Bool) -> Void) {
        let loginManager = LoginManager()
        loginManager.logOut()
        completion(true)
    }
    
}
