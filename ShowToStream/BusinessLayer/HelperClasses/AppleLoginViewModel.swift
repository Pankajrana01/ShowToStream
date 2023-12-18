//
//  AppleLoginViewModel.swift
//  KarGoCustomer
//
//  Created by Applify on 23/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import AuthenticationServices
import UIKit

@available(iOS 13.0, *)
class AppleLoginViewModel: BaseViewModel, ASAuthorizationControllerDelegate {
    var completionHandler: ((User) -> Void)?
    
    func login(completion: @escaping (_ user: User) -> Void) {
        self.completionHandler = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = User()
            user.loginType = .apple
            user.appleId = appleIDCredential.user
            
            user.firstName = appleIDCredential.fullName?.givenName ?? ""
            user.lastName = appleIDCredential.fullName?.familyName ?? ""
            user.fullName = "\(appleIDCredential.fullName?.givenName ?? "")" + "\(appleIDCredential.fullName?.familyName ?? "")"
            user.email = appleIDCredential.email ?? ""
            user.oauthToken = appleIDCredential.authorizationCode?.base64EncodedString() ?? ""
            
            self.completionHandler?(user)
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: user.socialId) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    break
                case .revoked:
                    // The Apple ID credential is revoked.
                    break
                case .notFound:
                    // No credential was found, so show the sign-in UI.
                    break
                default:
                    break
                }
            }
            
        } else if let _ = authorization.credential as? ASPasswordCredential {
            //            let username = passwordCredential.user
            //            let password = passwordCredential.password
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
        print("")
    }
}

@available(iOS 13.0, *)
extension AppleLoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.hostViewController.view.window!
    }
}
