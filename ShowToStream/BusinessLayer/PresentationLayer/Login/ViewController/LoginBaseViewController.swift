//
//  LoginBaseViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//


import UIKit

class LoginBaseViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }

    override func getViewModel() -> BaseViewModel {
        return loginBaseViewModel
    }

    lazy var loginBaseViewModel = LoginBaseViewModel(hostViewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any?) {
        self.loginBaseViewModel.loginButtonTapped()
    }

    @IBAction func signupButtonTapped(_ sender: Any?) {
        self.loginBaseViewModel.signupButtonTapped()
    }

    @IBAction func facebookButtonTapped(_ sender: Any?) {
        self.loginBaseViewModel.facebookButtonTapped()
    }
    
    @IBAction func appleButtonTapped(_ sender: Any?) {
        self.loginBaseViewModel.appleButtonTapped()
    }
    
    @IBAction func googleButtonTapped(_ sender: Any?) {
        self.loginBaseViewModel.googleButtonTapped()
    }

}
