//
//  WalkthroughViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class WalkthroughViewModel: BaseViewModel {
    func nextButtonTapped() {
        gotoPreferences()
    }

    func skipButtonTapped() {
        gotoPreferences()
    }

    private func gotoPreferences() {
        let contorller = PreferenceViewController.getController()
        contorller.clearNavigationStackOnAppear = true
        contorller.show(from: self.hostViewController)
    }
    
}
