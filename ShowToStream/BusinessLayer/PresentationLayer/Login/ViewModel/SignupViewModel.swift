//
//  SignupViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 30/12/20.
//

import Foundation

class SignupViewModel: BaseViewModel {
    var show: Show!
    var completionHandler: ((Bool) -> Void)?
    var user = UserModel.shared.user
    var commonUrls = [CommonUrl]()
    
    func gotoCreateProfile(isCome: String, user: User) {
        CreateProfileViewController.show(from: hostViewController, forcePresent: false, isCome: isCome, user: user, screenFlow: .signup) { success in
            if success { }
        }
    }
    
    func gotoLoginScreen(){
        LoginViewController.show(from: hostViewController, forcePresent: false, autoEmbedInNavigationControllerIfPresent: true)
    }
    
    func openWebPage(titlename:String, url:String){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: titlename, url: url, iscomeFrom: ""){ status in
        }
    }
    
  
}
