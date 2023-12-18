//
//  ResetPasswordViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 05/01/21.
//

import UIKit

class ResetPasswordViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.verificationCode
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.resetPassword
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    lazy var viewModel = ResetPasswordViewModel(hostViewController: self)
    
    @IBOutlet private weak var descriptionLable: UILabel!
    @IBOutlet private weak var backToLoginButton: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var resendView: UIView!
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false, email: String, isCome: String, waitingTime: Int,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! ResetPasswordViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.email = email
        controller.viewModel.waitingTime = waitingTime
        controller.viewModel.isCome = isCome
        controller.modalPresentationStyle = .fullScreen
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.timerLabel = timerLabel
        self.viewModel.resendView = resendView
        
        if self.viewModel.isCome == StringConstants.changePassword{
            self.backToLoginButton.isHidden = true
        }
        
        let mainString = WebConstants.weHave + "\(self.viewModel.email)" + WebConstants.pleaseClick
        
        let stringToColor = self.viewModel.email
        
        let range = (mainString as NSString).range(of: stringToColor)

        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)

        descriptionLable.attributedText = mutableAttributedString
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewAppeared()
    }
    
    @IBAction func goBackToLoginButton(_ sender: UIButton) {
        self.viewModel.gotoLoginScreen()
    }
    
    @IBAction func resendButton(_ sender: UIButton) {
        self.viewModel.resendButtonTapped()
    }
}
