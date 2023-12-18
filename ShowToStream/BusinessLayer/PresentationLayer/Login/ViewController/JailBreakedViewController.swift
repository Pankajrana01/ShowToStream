//
//  JailBreakedViewController.swift
//  KarGoRider
//
//  Created by Pankaj Rana on 24/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class JailBreakedViewController: BaseViewController {
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.jailBreaked
    }
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    lazy var viewModel = JailBreakedViewModel(hostViewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
