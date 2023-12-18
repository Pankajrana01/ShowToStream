//
//  MyAccountViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 16/12/20.
//

import UIKit

class MyAccountViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.myAccount
    }
       
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MyAccountViewController
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.completionHandler = completionHandler
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    lazy var viewModel: MyAccountViewModel = MyAccountViewModel(hostViewController: self)
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var myAccountTableView: UITableView!
    @IBOutlet private weak var userBackImage: UIImageView!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var manageProfilelabel: UILabel!
    @IBOutlet private weak var editButton: UIImageView!
    @IBOutlet private weak var cancelLabel: UILabel!
    
    class func updateController() -> BaseViewController {
        let controller = self.getController() as! MyAccountViewController
        return controller
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.collectionView = collectionView
        viewModel.tableView = myAccountTableView
        addCoverBGImage()
        
       
    }
   
    override func viewWillAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        
        self.viewModel.isShowCancel = false
     // to check presenter view is present ...
        if self.viewModel.user.becamePresenter == 2{
            self.viewModel.isPresenter = true
            self.viewModel.processDataForEarning()
        }else{
            self.viewModel.isPresenter = false
        }
        showManageProfile()
        self.collectionView.reloadData()
        self.myAccountTableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }

    @IBAction func manageProfileButton(_ sender: UIButton) {
        if self.viewModel.isShowCancel == false{
            showCancelProfile()
            self.viewModel.isShowCancel = true
            self.collectionView.reloadData()
        }else{
            showManageProfile()
            self.viewModel.isShowCancel = false
            self.collectionView.reloadData()
        }
    }
    
    func addCoverBGImage(){
        userBackImage.image = KUSERMODEL.selectedProfileImage
        userBackImage.contentMode = .scaleToFill
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = detailView.bounds
        blurredEffectView.clipsToBounds = true
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        userBackImage.addSubview(blurredEffectView)
    }
    
    
    func showManageProfile(){
        self.cancelLabel.isHidden = true
        self.manageProfilelabel.isHidden = false
        self.editButton.isHidden = false
    }
    
    func showCancelProfile(){
        DispatchQueue.main.async {
            UIView.transition(with: self.editButton, duration: 1.6,
                              options: .curveEaseOut,
                            animations: {
                                self.cancelLabel.isHidden = false
                                self.manageProfilelabel.isHidden = true
                                self.editButton.isHidden = true
                        })
        }
    }
}
extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
