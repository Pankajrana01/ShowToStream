//
//  SplashViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.splash
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.splash
    }

    @IBOutlet private weak var logoImageView: UIImageView!

    @IBOutlet private weak var leftCurtainImageView: UIImageView!
    @IBOutlet private weak var rightCurtainImageView: UIImageView!
    @IBOutlet private weak var shadowImageView: UIImageView!

    private var animationDuration: Double = 1
    
    lazy var viewModel: SplashViewModel = SplashViewModel(hostViewController: self)
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        logoImageView.alpha = 0.5
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: .appEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func didBecomeActive() {
        // animations were disturbed, now fix views positions without animation
        animationDuration = 0
        performAnimtaion()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(1) {
            self.performAnimtaion()
        }
    }
    
    private func performAnimtaion() {
        UIView.animate(withDuration: animationDuration) {
            self.logoImageView.transform = .identity
            self.logoImageView.alpha = 1
            
            self.leftCurtainImageView.transform = CGAffineTransform(translationX: -self.leftCurtainImageView.frame.size.width, y: 0)
            self.rightCurtainImageView.transform = CGAffineTransform(translationX: self.rightCurtainImageView.frame.size.width, y: 0)

            self.shadowImageView.alpha = 0
        } completion: { finished in
            if finished {
                self.viewModel.proceedToNextScreen()
            }
        }
    }
}
