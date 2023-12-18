//
//  SessionViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 15/01/21.
//

import UIKit

class SessionViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.session
    }
    
    lazy var viewModel: SessionViewModel = SessionViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController, session:[Sessions],
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! SessionViewController
        controller.show(over: host, session: session, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController, session:[Sessions],
              completionHandler: @escaping ((String) -> Void)) {
        self.viewModel.completionHandler = completionHandler
        self.viewModel.session = session
        self.show(over: host)
    }

    @IBOutlet private weak var sessionTableView: UITableView!
    
    @IBOutlet private weak var containerViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        
        if self.viewModel.session.count + 1 > 3{
            self.containerViewHeight.constant = 400
            sessionTableView.isScrollEnabled = true
        }else{
            self.containerViewHeight.constant = 400 - 70
            sessionTableView.isScrollEnabled = false
        }
        self.viewModel.tableView = sessionTableView
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews(){
//        self.viewModel.tableView.frame = CGRect(x: self.viewModel.tableView.frame.origin.x, y: self.viewModel.tableView.frame.origin.y, width: self.viewModel.tableView.frame.size.width, height: self.viewModel.tableView.contentSize.height)
//        self.viewModel.tableView.reloadData()
    }

}
