//
//  LoginConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

enum LoginType: Int {
    case email = 1, facebook, google, apple
}

enum Platform: String {
    case iOS = "IOS", android = "ANDROID"
}

enum LoginScreenState {
    case signIn
    case signUp
}

extension UIStoryboard {
    class var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
}

extension TableViewCellIdentifier {
    static let sessionTableViewCell            = "SessionTableViewCell"
}

extension TableViewNibIdentifier {
    static let sessionTableViewCell            = "SessionTableViewCell"
}

extension ViewControllerIdentifier {
    static let login                             = "LoginViewController"
    static let signUp                            = "SignupViewController"
    static let createProfile                     = "CreateProfileViewController"
    static let webPage                           = "WebPageViewController"
    static let session                           = "SessionViewController"
    static let jailBreaked                      = "isJailBreaked"
}

extension StringConstants {
    static let termsOfServices                  = "Terms of Services"
    static let privacyPolicy                    = "Privacy Policy"
    static let social                           = "social"
    static let splash                           = "splash"
    static let email                            = "email"
}
    
