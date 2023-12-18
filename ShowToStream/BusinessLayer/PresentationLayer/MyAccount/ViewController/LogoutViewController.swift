//
//  LogoutViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit

class LogoutViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.logout
    }
    
    lazy var viewModel: LogoutViewModel = LogoutViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((Bool) -> Void)) {
        let controller = self.getController() as! LogoutViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((Bool) -> Void)) {
        self.viewModel.completionHandler = completionHandler
        self.show(over: host)
    }
    
    @IBOutlet private weak var yesButon: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noButton.backgroundColor = UIColor.appVoilet
        self.yesButon.backgroundColor = .clear
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        viewModel.logoutButtonTapped()
    }

}
