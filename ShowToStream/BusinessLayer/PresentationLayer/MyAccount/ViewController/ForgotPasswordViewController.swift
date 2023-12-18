//
//  ForgotPasswordViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 18/12/20.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.forgotPassword
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false, isCome: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! ForgotPasswordViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isCome = isCome
        controller.modalPresentationStyle = .fullScreen
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    lazy var viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel(hostViewController: self)
    private var scrollView = UIScrollView()
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var sendButtonBottomConstraints: NSLayoutConstraint!
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        // Do any additional setup after loading the view.
        
       // let notificationCenter = NotificationCenter.default
        
       // notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
      //  notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.sendButtonBottomConstraints.constant = 20
        } else {
            self.sendButtonBottomConstraints.constant = keyboardViewEndFrame.height + 10
        }
        
        // Get required info out of the notification
        if let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps our scroll view
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset & scroll indicator to avoid the keyboard
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        viewModel.checkValidation(emailTextField: emailTextField)
    }
    
}
