//
//  HomeViewController.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
class HomeViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.home
    }
    
    lazy var viewModel = HomeViewModel(hostViewController: self)
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var topNavigationBar: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.collectionView = collectionView
        viewModel.sessionCreated = KUSERMODEL.isLoggedIn()
       // viewModel.startShimmerEffect()
        avatarImageView.image = KUSERMODEL.selectedProfileImage
        //check for user session ...
        viewModel.syncPreferences()
        
        if KAPPDELEGATE.needsRirectToMyAccount {
            KAPPDELEGATE.needsRirectToMyAccount = false
            viewModel.avatarButtonTapped()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self.viewModel)
        
        collectionView.visibleCells.forEach { ($0 as? TrailerPlayerInCollectionViewCell)?.stopPlayingTrailer() }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self.viewModel)
        collectionView.reloadData()
    }
    
    @IBAction func avatarButtonTapped(_ sender: Any) {
        self.viewModel.avatarButtonTapped()
    }
}

extension HomeViewController : RequestMyAccountUpdatedListner{
    func requestMyAccountUpdated(Update: Bool) {
        if Update == true {
            self.viewModel.avatarButtonTapped()
        }
    }
}
