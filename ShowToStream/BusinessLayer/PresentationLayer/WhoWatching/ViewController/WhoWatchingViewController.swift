//
//  WhoWatchingViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 04/01/21.
//

import UIKit

class WhoWatchingViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.whoWatching
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.whoWatching
    }
    
    class func show(from viewController: UIViewController, forcePresent: Bool = true, autoEmbedInNavigationControllerIfPresent: Bool = true) {
        (self.getController() as! WhoWatchingViewController).show(from: viewController, forcePresent: forcePresent, autoEmbedInNavigationControllerIfPresent: autoEmbedInNavigationControllerIfPresent)
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

    lazy var viewModel: WhoWatchingViewModel = WhoWatchingViewModel(hostViewController: self)

    @IBOutlet private weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.collectionView = collectionView
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            collectionViewWidth.constant = self.view.frame.size.width / 2 - 100
        }else{
            collectionViewWidth.constant = self.view.frame.size.width - 80
        }
    }
    
}
