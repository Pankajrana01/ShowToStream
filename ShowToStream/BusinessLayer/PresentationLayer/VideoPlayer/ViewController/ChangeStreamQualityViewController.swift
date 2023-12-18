//
//  ChangeStreamQualityViewController.swift
//  ShowToStream
//
//  Created by 1312 on 30/12/20.
//

import UIKit

class ChangeStreamQualityViewController: BaseAlertViewController {
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.videoPlayer
    }
    
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    override class func identifier() -> String {
        return ViewControllerIdentifier.changeStreamQuality
    }
    lazy var viewModel = ChangeStreamQualityViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    
    @discardableResult
    class func show(over host: UIViewController, videoQuality: [String], selectedIndex: Int,
                    completionHandler: @escaping ((Int, String) -> Void)) -> ChangeStreamQualityViewController {
        let controller = self.getController() as! ChangeStreamQualityViewController
        controller.show(over: host, videoQuality: videoQuality, selectedIndex: selectedIndex, completionHandler: completionHandler)
        return controller
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!

    @IBAction func actionOK(_ sender: Any) {
        viewModel.okButtonTapped()
    }
    
    @IBAction func actioncancel(_ sender: Any) {
        viewModel.cancelButtonTapped()
    }
    
    func show(over host: UIViewController, videoQuality: [String], selectedIndex: Int,
                    completionHandler: @escaping ((Int, String) -> Void)) {
        self.viewModel.completionHandler = completionHandler
        self.viewModel.videoQuality = videoQuality
        self.viewModel.selectedIndex = selectedIndex
        self.show(over: host)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.tableViewHeight = tableViewHeight
        self.viewModel.tableView = tableView
    }

}
