//
//  SearchViewController.swift
//  ShowToStream
//
//  Created by Applify on 05/01/21.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.search
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.search
    }
    @IBOutlet private weak var placeholderView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!

    lazy var viewModel = SearchViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController, forcePresent: Bool = false, isCome: String) {
        let controller = SearchViewController.getController() as! SearchViewController
        controller.show(from: viewController, forcePresent: forcePresent, isCome: isCome)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = false, isCome: String) {
        viewModel.isCome = isCome
        show(from: viewController, forcePresent: forcePresent)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //backButton.isHidden = self.navigationController!.viewControllers.count == 1
        titleLabel.text = viewModel.title
        viewModel.sessionCreated = KUSERMODEL.isLoggedIn()
        viewModel.collectionView = collectionView
        viewModel.placeholderView = placeholderView
        viewModel.titleLabel = titleLabel
        viewModel.searchBar = searchBar
        viewModel.backButton = backButton
        searchContainer.layer.borderWidth = 0.7
        searchContainer.layer.borderColor = UIColor.appSearchBorder.cgColor
        self.viewModel.loadData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
       
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if viewModel.isCome == StringConstants.watchList{
            self.backButtonTapped(sender)
        }else{
            self.viewModel.backButtonTapped()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.isCome == StringConstants.watchList{
            backButton.isHidden = false
        }else{
            if viewModel.displayShows{
                backButton.isHidden = false
            }else{
                backButton.isHidden = true
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        viewModel.keyboardHeight = 0
    }

    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            viewModel.keyboardHeight = keyboardRectangle.height
        }
    }
}
