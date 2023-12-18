//
//  PreferenceViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class PreferenceViewController: BaseViewController {
    var isForCreateNewProfile: Bool = false

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.preference
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.preference
    }
    
    lazy var viewModel = PreferenceViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerViewHeight: NSLayoutConstraint!

    class func show(from viewController: UIViewController, forcePresent: Bool = false, profile: Profile?, completionHandler: (() -> Void)? = nil ) {
        (self.getController() as! PreferenceViewController).show(from: viewController, forcePresent: forcePresent, profile: profile, completionHandler: completionHandler)
    }
    
    func show(from viewController: UIViewController, forcePresent: Bool = false, profile: Profile?, completionHandler: (() -> Void)? = nil ) {
        viewModel.preferencesSetNavigationBlock = completionHandler
        viewModel.profile = profile
        show(from: viewController, forcePresent: forcePresent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.isForCreateNewProfile = self.isForCreateNewProfile
        viewModel.collectionView = collectionView
        if clearNavigationStackOnAppear || (self.navigationController?.viewControllers.count ?? 0) < 2 {
           // headerViewHeight.constant = 0
            backButton.isHidden = true
            skipButton.isHidden = false
        }else{
            backButton.isHidden = false
            skipButton.isHidden = true
        }
    }
        
    @IBAction func confirmButtonTapped(_ sender: Any?) {
        self.viewModel.confirmButtonTapped()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        self.viewModel.skipButtonTapped()
    }
    
}
