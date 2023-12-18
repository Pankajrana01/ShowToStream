//
//  PlayTvViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 22/12/20.
//

import UIKit

class PlayTvViewController:  BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.playTV
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! PlayTvViewController
        controller.viewModel.completionHandler = completionHandler
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    lazy var viewModel = PlayTvViewModel(hostViewController: self)
    
    @IBOutlet private weak var pinView: SVPinView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePinView()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
    }
    
    func configurePinView() {
        pinView.pinLength = 4
        pinView.interSpace = 24
        pinView.textColor = UIColor.white
        pinView.borderLineColor = UIColor.appGray
        pinView.activeBorderLineColor = UIColor.appGray
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = true
        pinView.allowsWhitespaces = false
        pinView.style = .none
        pinView.fieldBackgroundColor = UIColor.appGray.withAlphaComponent(0.3)
        pinView.activeFieldBackgroundColor = UIColor.appGray.withAlphaComponent(0.5)
        pinView.fieldCornerRadius = 6
        pinView.activeFieldCornerRadius = 6
        pinView.placeholder = ""
        pinView.deleteButtonAction = .deleteCurrent
        pinView.keyboardAppearance = .default
        pinView.tintColor = .white
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        
        pinView.font = UIFont.appBoldFont(with: 24)
        pinView.keyboardType = .default
 
        pinView.didChangeCallback = { pin in
            print("\(pin)")
            if pin.count == 4 {
                self.view.endEditing(true)
                self.viewModel.otpFilled(otpText: pin)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

