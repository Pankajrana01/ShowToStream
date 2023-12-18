//
//  WatchlistViewController.swift
//  ShowToStream
//
//  Created by Applify on 04/01/21.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class WatchlistViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.watchlist
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.watchlist
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false, title:String, comeFrom:String) {
        let controller = self.getController() as! WatchlistViewController
        controller.viewModel.titleName = title
        controller.viewModel.comeFrom = comeFrom
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    // used for show category data...
    class func show(from viewController: UIViewController, forcePresent: Bool = false, selectedCategoryId: String,title:String) {
        let controller = WatchlistViewController.getController() as! WatchlistViewController
        controller.show(from: viewController, forcePresent: forcePresent, selectedCategoryId: selectedCategoryId, title: title)
    }
    func show(from viewController: UIViewController, forcePresent: Bool = false, selectedCategoryId: String, title:String) {
        viewModel.selectedCategoryId = selectedCategoryId
        viewModel.titleName = title
        show(from: viewController, forcePresent: forcePresent)
    }
    
    
    @IBOutlet private weak var titlelabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeholderView: UIView!
    @IBOutlet private weak var topBar: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var exploreMoreView: GradientView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var exploreMoreBottomConstraints: NSLayoutConstraint!
    
    
    lazy var viewModel = WatchlistViewModel(hostViewController: self)
  
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.exploreMoreBottomConstraints.constant = 106
        }else{
            self.exploreMoreBottomConstraints.constant = 76
        }
        var fullString = NSMutableAttributedString()
        if viewModel.comeFrom == WebConstants.continueWatching{
            self.titleLabel.text = WebConstants.continueWatching
            self.exploreMoreView.isHidden = true
            self.backButton.isHidden = false
            fullString = NSMutableAttributedString(string: "")
            titlelabel.text = StringConstants.noVideoFound
        }
        else if self.viewModel.selectedCategoryId != ""{
            self.titleLabel.text = self.viewModel.titleName
            self.exploreMoreView.isHidden = true
            self.backButton.isHidden = false
            titlelabel.text = StringConstants.noVideoFound
            fullString = NSMutableAttributedString(string: "")
        }
        else{
            self.exploreMoreView.isHidden = false
            self.backButton.isHidden = true
            titlelabel.text = StringConstants.feelLonelyHere
            fullString = NSMutableAttributedString(string: StringConstants.youHaveNotAddedAnyShows)
        }
        
        viewModel.tableView = tableView
        viewModel.topBar = topBar
        viewModel.placeholderView = placeholderView
    
        fullString.addAttribute(NSAttributedString.Key.font,
                                value: UIFont.appLightFont(with: 14),
                                range: NSRange(location: 0, length: fullString.length))
        fullString.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: UIColor.appGray,
                                range: NSRange(location: 0, length: fullString.length))

        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 17
        paragraphStyle.maximumLineHeight = 17
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        fullString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: fullString.length))

        // draw the result in a label
        descriptionLabel.attributedText = fullString
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.comeFrom == WebConstants.continueWatching{
            self.viewModel.processDataForLoginContinueList()
        } // Call api for selected category data listing ...
        else if self.viewModel.selectedCategoryId != ""{
            self.viewModel.getCategoryData(id: self.viewModel.selectedCategoryId)
        }
        else{
            self.viewModel.processDataForWatchList()
        }
    }
    
    @IBAction func exploreButtonTapped(_ sender: Any?) {
        self.viewModel.exploreButtonTapped()
    }
}
