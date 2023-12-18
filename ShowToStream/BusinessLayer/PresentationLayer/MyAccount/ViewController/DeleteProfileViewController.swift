//
//  DeleteProfileViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 29/12/20.
//

import UIKit

class DeleteProfileViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.deleteProfile
    }
    
    lazy var viewModel: DeleteProfileViewModel = DeleteProfileViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    profile: Profile,
                    completionHandler: @escaping (() -> Void)) {
        let controller = self.getController() as! DeleteProfileViewController
        controller.show(over: host, profile: profile, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              profile: Profile,
              completionHandler: @escaping (() -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.profile = profile
        show(over: host)
    }
    
    @IBOutlet private weak var yesButon: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noButton.backgroundColor = UIColor.appVoilet
        self.yesButon.backgroundColor = .clear
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        viewModel.deleteButtonTapped()
    }
    

}
