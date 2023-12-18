//
//  CheckAccountViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 04/01/21.
//

import Foundation

class CheckAccountViewModel : BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var commonUrls = [CommonUrl]()
    func gotoSingUp() {
        SignupViewController.show(from: hostViewController, forcePresent: true, autoEmbedInNavigationControllerIfPresent: true)
    }
    
    func gotoSigIn() {
        LoginViewController.show(from: hostViewController, forcePresent: true, autoEmbedInNavigationControllerIfPresent: true)
    }
    
    func openWebPage(titlename:String, url:String){
        WebPageViewController.show(from: hostViewController, forcePresent: false, title: titlename, url: url, iscomeFrom: ""){ status in
        }
    }

}
