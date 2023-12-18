//
//  AboutViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 18/12/20.
//

import UIKit

class AboutViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.about
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    openUrl : String, title: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! AboutViewController
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.pageUrl = openUrl
        controller.viewModel.pageTitle = title
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    lazy var viewModel: AboutViewModel = AboutViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = viewModel.pageTitle
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }

}
