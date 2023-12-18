//
//  BaseViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import SwiftMessages
import UIKit

protocol BaseViewControllerProtocol {
    func getViewModel() -> BaseViewModel
    func refreshUI()
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationGR = self.navigationController?.interactivePopGestureRecognizer,
            gestureRecognizer == navigationGR {
            if self.isViewLoaded && self.view.window != nil {
                return false
            }
        }
        return true
    }
}

class BaseViewController: UIViewController {
 
    let bgImageView = UIImageView()
    
    class func storyboard() -> UIStoryboard {
        fatalError("Child should override")
    }
    
    class func identifier() -> String {
        fatalError("Child should override")
    }
    
    func getViewModel() -> BaseViewModel {
        fatalError("Child should override")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    func refreshUI() {
    }
    
    func isNavigationHidden(isHidden:Bool)  {
        self.navigationController?.isNavigationBarHidden = isHidden
    }

    class func getController() -> BaseViewController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! BaseViewController
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

    override func viewDidLoad() {
        super.viewDidLoad()
        getViewModel().viewLoaded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("original viewWillDisappear")
    }

    var clearNavigationStackOnAppear: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let  navVC = self.navigationController {
            navVC.interactivePopGestureRecognizer?.delegate = navVC.viewControllers.count == 1 ? self: nil

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if clearNavigationStackOnAppear {
            clearNavigationStackOnAppear = false
            self.navigationController?.viewControllers = [self]
        }
    }
}
