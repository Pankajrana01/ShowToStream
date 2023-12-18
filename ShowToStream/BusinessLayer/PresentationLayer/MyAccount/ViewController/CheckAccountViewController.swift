//
//  CheckAccountViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 04/01/21.
//

import UIKit

class CheckAccountViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.checkAccount
    }
    
    lazy var viewModel: CheckAccountViewModel = CheckAccountViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((Bool) -> Void)) {
        let controller = self.getController() as! CheckAccountViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((Bool) -> Void)) {
        self.viewModel.completionHandler = completionHandler
        self.show(over: host)
    }
    @IBOutlet private weak var continueLabel: UILabel!
    @IBOutlet private weak var singupButon: UIButton!
    @IBOutlet private weak var signinButton: UIButton!
    
    private var tapGesture = UITapGestureRecognizer()
    private var termsRange = NSRange()
    private var privacyRange = NSRange()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        
        
        self.singupButon.backgroundColor = UIColor.appVoilet
        self.signinButton.backgroundColor = .clear
        addTapGesture()
        
        // load common Url's
        KAPPDELEGATE.shouldRefreshCommonUrls = true
        KAPPDELEGATE.loadData { urls in
            self.viewModel.commonUrls = urls!
        }
        
        // Do any additional setup after loading the view.
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
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        self.singupButon.backgroundColor = UIColor.appVoilet
        self.signinButton.backgroundColor = .clear
        self.viewModel.gotoSingUp()
        
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        self.singupButon.backgroundColor = UIColor.clear
        self.signinButton.backgroundColor = UIColor.appVoilet
        self.viewModel.gotoSigIn()
    }
    
    

}
