//
//  SignupViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 30/12/20.
//

import UIKit

class SignupViewController: LoginBaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.signUp
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController, forcePresent: Bool = true, autoEmbedInNavigationControllerIfPresent: Bool = true) {
        (self.getController() as! SignupViewController).show(from: viewController, forcePresent: forcePresent, autoEmbedInNavigationControllerIfPresent: autoEmbedInNavigationControllerIfPresent)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = true, autoEmbedInNavigationControllerIfPresent: Bool = true) {
        if forcePresent, autoEmbedInNavigationControllerIfPresent {
            let navigationVC = UINavigationController(rootViewController: self)
            navigationVC.isNavigationBarHidden = true
            navigationVC.modalPresentationStyle = .fullScreen
            viewController.present(navigationVC, animated: true, completion: nil)
        } else {
            self.show(from: viewController, forcePresent: forcePresent)
        }
    }

    lazy var viewModel: SignupViewModel = SignupViewModel(hostViewController: self)
    private var tapGesture = UITapGestureRecognizer()
    private var termsRange = NSRange()
    private var privacyRange = NSRange()
    
    @IBOutlet private weak var continueLabel: UILabel!
    @IBOutlet private weak var coverImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateBackground()
        addTapGesture()
        KAPPDELEGATE.shouldRefreshCommonUrls = true
        KAPPDELEGATE.loadData { urls in
            self.viewModel.commonUrls = urls!
        }
    }
    
    //Add cover image animation ....
    func animateBackground(){
        UIView.animate(withDuration: 12.0, delay: 0.0, options: [.curveLinear], animations: {
            self.coverImage.frame = self.coverImage.frame.offsetBy(dx: 1 * self.coverImage.frame.origin.x+20, dy: 0.0)
        }, completion: nil)
        
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
           // self.viewModel.commonUrls
            self.viewModel.openWebPage(titlename: StringConstants.termsOfServices, url: self.viewModel.commonUrls[4].url)
            
        } else if (sender?.didTapAttributedTextInLabel(label: self.continueLabel, inRange: privacyRange))! {
            print(StringConstants.privacyPolicy)
            self.viewModel.openWebPage(titlename: StringConstants.privacyPolicy, url: self.viewModel.commonUrls[2].url)
            
        } else {
            print("Tapped none")
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if let loginVC = (self.presentingViewController as? UINavigationController)?.topViewController as? LoginViewController {
            self.presentingViewController?.dismiss(animated: true, completion: {
                loginVC.backButtonTapped(sender)
            });
        } else {
            self.backButtonTapped(sender)
        }
    }
    
    @IBAction func emailButton(_ sender: UIButton) {
        self.viewModel.gotoCreateProfile(isCome: "", user: self.viewModel.user)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.viewModel.gotoLoginScreen()
    }
    
}


