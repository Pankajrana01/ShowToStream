//
//  VerifyShowViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 10/03/21.
//

import UIKit

class VerifyShowViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.verificationCode
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.verifyShow
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    lazy var viewModel = VerifyShowViewModel(hostViewController: self)
    
    private var code = ""
    
    @IBOutlet private weak var pinView: SVPinView!
    @IBOutlet private weak var continueButton: UIButton!
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    id:String,
                    url: String,
                    completionHandler: @escaping (Bool) -> Void) {
        
        let controller = self.getController() as! VerifyShowViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.showId = id
        controller.viewModel.url = url
        controller.modalPresentationStyle = .fullScreen
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePinView()
        // Do any additional setup after loading the view.
    }
    
    private func configurePinView() {
        pinView.pinLength = 6
        pinView.interSpace = 10
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
        
        pinView.font = UIFont.appBoldFont(with: 22)
        pinView.keyboardType = .default
 
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
            if pin.count == 6 {
                self.code = pin
                self.view.endEditing(true)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
   
    @IBAction func continueButton(_ sender: Any) {
        self.viewModel.otpFilled(otpText: self.code)
    }
   
}
