//
//  UserAccountModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit

class UserAccountDetailModel: BaseViewModel {
    var user = KUSERMODEL.user
    var storedUser = KAPPSTORAGE.user
    func editAccountButtonTapped() {
        EditUserDetailViewController.show(from: self.hostViewController, forcePresent: false)
    }
    
    func logoutButtonTapped(){
        let controller = LogoutViewController.getController() as! LogoutViewController
        controller.dismissCompletion = { }
        controller.show(over: self.hostViewController) { status in
        }
    }
    
    func changePasswordButtonTapped(){
        ChangePasswordViewController.show(from: self.hostViewController, forcePresent: false)
    }
    
}
