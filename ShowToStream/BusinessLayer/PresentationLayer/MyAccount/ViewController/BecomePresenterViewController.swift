//
//  BecomePresenterViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 18/12/20.
//

import UIKit

class BecomePresenterViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.becomePresenter
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! BecomePresenterViewController
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.completionHandler = completionHandler
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    lazy var viewModel: BecomePresenterViewModel = BecomePresenterViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    private var tapGesture = UITapGestureRecognizer()
    private var termsRange = NSRange()
    private var privacyRange = NSRange()
    @IBOutlet private weak var continueLabel: UILabel!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var characterCount: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var fullNameTextFileld: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var companyNameTextField: UITextField!
    @IBOutlet private weak var messageView: UIView!{
        didSet {
            self.messageView.layer.borderColor = UIColor.appGray.cgColor
            self.messageView.layer.borderWidth = 1
            self.messageView.layer.cornerRadius = 6
        }
    }
    private var limit: Int = 250
    private var charCount = 0
    private var textChanged: ((String) -> Void)?
    private var message: String! {
        didSet {
            self.messageTextView.text = message
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.messageTextView = messageTextView
        self.characterCount.isHidden = true
        messageTextView.text = StringConstants.briefAbout
        messageTextView.textColor = UIColor.appGray
        // Do any additional setup after loading the view.
        
        // load common Url's
        KAPPDELEGATE.shouldRefreshCommonUrls = true
        KAPPDELEGATE.loadData { urls in
            self.viewModel.commonUrls = urls!
        }
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        
        self.phoneNumberTextField.addLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                           target: self.viewModel,
                                           selector: #selector(EditUserDetailViewModel.selectCountryTapped))

        self.viewModel.countryCodeUpated = {
            self.phoneNumberTextField.addLeftButton(accessories: [self.viewModel.countryCode, #imageLiteral(resourceName: "ic_downArrow") ],
                                                    target: self.viewModel,
                                                    selector: #selector(self.viewModel.selectCountryTapped))
        }
        self.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: StringConstants.phoneNumberPlaceholder,
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.appGray, NSAttributedString.Key.font: UIFont.appLightFont(with: 16)])
        refreshUI()
        addTapGesture()
    }
    
    func addTapGesture(){
        tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(SignupViewController.handleTap(sender:)))
        tapGesture.delegate = self
        let text = (self.continueLabel.text)!
        
        termsRange = (text as NSString).range(of: StringConstants.termsOfServices)

        privacyRange = (text as NSString).range(of: StringConstants.privacyPolicy)
        
        self.continueLabel.isUserInteractionEnabled = true
        self.continueLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if (sender?.didTapAttributedTextInLabel(label: self.continueLabel, inRange: termsRange))! {
            print(StringConstants.termsOfServices)
            self.viewModel.openWebPage(titlename: StringConstants.termsOfServices, url: self.viewModel.commonUrls[4].url)
            
        } else if (sender?.didTapAttributedTextInLabel(label: self.continueLabel, inRange: privacyRange))! {
            print(StringConstants.privacyPolicy)
            self.viewModel.openWebPage(titlename: StringConstants.privacyPolicy, url: self.viewModel.commonUrls[2].url)
            
        } else {
            print("Tapped none")
        }
    }
    
    
    override func refreshUI() {
        super.refreshUI()
        fullNameTextFileld.text = viewModel.user.fullName
        emailTextField.text = viewModel.user.email
        let phNumber = viewModel.user.phoneNumber.replacingOccurrences(of: " ", with: "")
        phoneNumberTextField.text = phNumber.replacingOccurrences(of: self.viewModel.countryCode, with: "")
        //phoneNumberTextField.text = viewModel.user.phoneNumber.replacingOccurrences(of: " ", with: "")
       emailTextField.isUserInteractionEnabled = false
        
    }
    @IBAction func submitButton(_ sender: UIButton) {
        viewModel.checkValidation(fullNameTextField: fullNameTextFileld, emailTextField: emailTextField, messageTextView: messageTextView, phoneTextField: phoneNumberTextField, companyNameTextField: companyNameTextField)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
    
}
extension BecomePresenterViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextTF = textField.superview?.viewWithTag(nextTag) as UIResponder?
        if nextTF != nil {
            nextTF?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == phoneNumberTextField {
//            if range.length > 0 {
//                return true
//            }
//            if string == "" {
//                return false
//            }
//            if range.location > 17 {
//                return false
//            }
//            var originalText = textField.text
//            let replacementText = string.replacingOccurrences(of: " ", with: "")
//            
//            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
//                return false
//            }
//            
//            if range.location == 3 || range.location == 7 {
//                originalText?.append(" ")
//                textField.text = originalText
//            }
//            return true
//        }
//        return true
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appGray {
            textView.text = nil
            textView.textColor = UIColor.white
            self.messageView.layer.borderColor = UIColor.appVoilet.cgColor
            self.characterCount.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = StringConstants.briefAbout
            textView.textColor = UIColor.appGray
            self.characterCount.isHidden = true
        }
        self.messageView.layer.borderColor = UIColor.appGray.cgColor
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == UIColor.white {
            textView.textColor = UIColor.white
            self.messageView.layer.borderColor = UIColor.appVoilet.cgColor
            self.characterCount.isHidden = false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textRange = Range(range, in: textView.text) {
            let  finalString = textView.text.replacingCharacters(in: textRange, with: text)
            if finalString.count <= 250{
                let char = self.limit - finalString.count
                print(char)
                self.characterCount.text = "\(char)" + "/250"
                return finalString.count <= self.limit
            }else{
                return false
            }
        }
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
}
