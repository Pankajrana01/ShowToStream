//
//  VerificationCodeVC.swift
//  KarGoRider
//
//  Created by Dev on 30/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class VerificationCodeVC: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.verificationCode
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.VerificationCodeVC
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    lazy var viewModel = VerificationCodeViewModel(hostViewController: self)
    
    private var code = ""
    
    @IBOutlet private weak var userEmail: UILabel!
    @IBOutlet private weak var pinView: SVPinView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var resendButton: UIButton!
    @IBOutlet private weak var resendView: UIView!
    @IBOutlet private weak var continueButton: UIButton!
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    screenFlow: PNVSceenFlow,
                    secondaryEmailForUpdate: String? = nil,
                    waitingTime: Int = 0,
                    completionHandler: @escaping (Bool) -> Void) {
        
        let controller = self.getController() as! VerificationCodeVC
        controller.viewModel.completionHandler = completionHandler
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.screenFlow = screenFlow
        controller.viewModel.secondaryEmailForUpdate = secondaryEmailForUpdate
        controller.viewModel.waitingTime = waitingTime
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    override func viewDidLoad() {
        self.viewModel.timerLabel = self.timerLabel
        super.viewDidLoad()
        updateRecord()
        
        self.viewModel.email = self.userEmail
        self.viewModel.resendButton = self.resendButton
        self.viewModel.resendView = self.resendView
        self.viewModel.continueButton = self.continueButton
        
        self.configurePinView()
        
        if viewModel.screenFlow == .login{
            self.resendView.isHidden = false
        } else if viewModel.screenFlow == .splash{
            self.resendView.isHidden = true
        } else{
            self.resendView.isHidden = true
           // self.viewModel.startTimer()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        if viewModel.screenFlow == .splash {
            self.viewModel.gotoLoginScreen()
        }else{
            self.backButtonTapped(sender)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewAppeared()
    }
    
    private func updateRecord(){
        if self.viewModel.storedUser != nil{
            if self.viewModel.storedUser!.email != "" {
                if viewModel.screenFlow == .editUserDetails {
                    self.userEmail.text = viewModel.secondaryEmailForUpdate
                } else {
                    self.userEmail.text = self.viewModel.storedUser!.email
                }
            }
        }
    }

    private func configurePinView() {
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
        pinView.keyboardType = .numberPad
 
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
            if pin.count == 4 {
                self.code = pin
                self.view.endEditing(true)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
   
    @IBAction func continueButton(_ sender: Any) {
        self.viewModel.otpFilledByEmail(otpText: self.code)
    }

    @IBAction func resendButtonTapped(_ sender: Any?) {
        self.pinView.clearPin()
        self.code = ""
        self.viewModel.resendButtonTapped()
    }
}
