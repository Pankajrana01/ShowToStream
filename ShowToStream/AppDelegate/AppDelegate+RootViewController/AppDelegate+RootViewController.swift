//
//  AppDelegate+RootViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension AppDelegate {
    func updateRootController(_ controller: UIViewController,
                              transitionDirection: TransitionOptions.Direction = .toRight,
                              embedInNavigationController: Bool = false) {
        guard let window = self.window else {
            return
        }
        var transition = TransitionOptions(direction: transitionDirection)
        transition.duration = 0.4
        transition.style = .easeInOut
        transition.background = TransitionOptions.Background.solidColor(.black)
        
        if embedInNavigationController {
            let navVC = UINavigationController(rootViewController: controller)
            navVC.setNavigationBarHidden(true, animated: false)
            window.setRootViewController(navVC,
                                         options: transition)
        } else {
            window.setRootViewController(controller,
                                         options: transition)
        }
    }
}
