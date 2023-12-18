//
//  LandingViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class LandingViewController: UITabBarController {
    
    class func storyboard() -> UIStoryboard {
        return UIStoryboard.landing
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.landing
    }
    
    class func getController() -> LandingViewController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! LandingViewController
    }
   
    class func show(from viewController: UIViewController, forcePresent: Bool = false) {
        let vc = self.getController()
        vc.show(from: viewController, forcePresent: forcePresent)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = false) {
        viewController.endEditing(true)
        DispatchQueue.main.async {
            if forcePresent {
                viewController.present(self, animated: true, completion: nil)
            } else {
                viewController.show(self, sender: nil)
            }
        }
    }

    var clearNavigationStackOnAppear: Bool = false
    var sessionCreated: Bool = false
    var user = UserModel.shared.user
    var heightConstraint = NSLayoutConstraint()
    
    @IBOutlet private weak var customTabBar: UIView!
    @IBOutlet private weak var selectionIndicatorView: GradientView!
    @IBOutlet private var selectionIndicatorViewCenterY: [NSLayoutConstraint]!
    @IBOutlet private var tabBarButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        sessionCreated = KUSERMODEL.isLoggedIn()
        configureTabBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if clearNavigationStackOnAppear {
            clearNavigationStackOnAppear = false
            self.navigationController?.viewControllers = [self]
        }
    }
    
    func selectTab(at index: Int) {
        if let button = tabBarButtons.first (where:  { $0.tag  == index }) {
            tabBarButtonTapped(button)
        }
    }
    
    @IBAction func tabBarButtonTapped(_ sender: UIButton) {
        if self.selectedIndex == sender.tag {
            return
        } else {
            if sender.tag == 2{
                if !sessionCreated {
                    self.checkforAccount()
                }else{
                    tabBarButtons.forEach { $0.setImage(TabItem(rawValue: $0.tag)?.icon, for: .normal) }
                    sender.setImage(TabItem(rawValue: sender.tag)?.selectedIcon, for: .normal)
                    selectionIndicatorViewCenterY.forEach{ $0.priority = .defaultLow  }
                    selectionIndicatorViewCenterY.first(where: { $0.identifier == "\(sender.tag)" })?.priority = .defaultHigh
                    self.selectedIndex = sender.tag
                }
            }else{
                tabBarButtons.forEach { $0.setImage(TabItem(rawValue: $0.tag)?.icon, for: .normal) }
                sender.setImage(TabItem(rawValue: sender.tag)?.selectedIcon, for: .normal)
                selectionIndicatorViewCenterY.forEach{ $0.priority = .defaultLow  }
                selectionIndicatorViewCenterY.first(where: { $0.identifier == "\(sender.tag)" })?.priority = .defaultHigh
                self.selectedIndex = sender.tag
            }
        }
    }
    
    func checkforAccount(){
        let controller = CheckAccountViewController.getController() as! CheckAccountViewController
        controller.dismissCompletion = {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name.continuePlayingTrailer, object: nil)
        }
        controller.show(over: self) { status in
        }
    }
    
    private func configureTabBar() {
        guard let view = view,
              let window = KAPPDELEGATE.window,
              let customTabBar = customTabBar else {
            return
        }

        self.tabBar.isHidden = true

        view.addSubview(customTabBar)

        var bottomValue: CGFloat = 4.0
        if window.safeAreaInsets.bottom > 0 {
            bottomValue += window.safeAreaInsets.bottom
        }
            
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: view,
                                                   attribute: .trailing,
                                                   relatedBy: .equal,
                                                   toItem: customTabBar,
                                                   attribute: .trailing,
                                                   multiplier: 1,
                                                   constant: 49)

        let trailingConstraint = NSLayoutConstraint(item: customTabBar,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: view,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 49)

        let bottomConstraint = NSLayoutConstraint(item: view,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: customTabBar,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: bottomValue)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            heightConstraint = NSLayoutConstraint(item: customTabBar,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 56)
        case .pad:
            heightConstraint = NSLayoutConstraint(item: customTabBar,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 86)
        case .unspecified:
            break
        case .tv:
            break
        case .carPlay:
            break
        case .mac:
            break
        @unknown default:
            break
        }
        
        view.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightConstraint])
        customTabBar.layoutIfNeeded()
        customTabBar.cornerRadius = customTabBar.bounds.size.height / 2
        selectionIndicatorView.cornerRadius = customTabBar.bounds.size.height / 2
    }
    
}


