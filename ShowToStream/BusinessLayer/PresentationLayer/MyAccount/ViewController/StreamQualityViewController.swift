//
//  StreamQualityViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 23/12/20.
//

import UIKit

class StreamQualityViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.streamQuality
    }
    
    lazy var viewModel: StreamQualityViewModel = StreamQualityViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((Bool) -> Void)) {
        let controller = self.getController() as! StreamQualityViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((Bool) -> Void)) {
        self.viewModel.completionHandler = completionHandler
        self.show(over: host)
    }
    
    @IBOutlet private weak var goodQualityView: UIView!
    @IBOutlet private weak var goodQualityCheckImage: UIImageView!
    @IBOutlet private weak var highQualityView: UIView!
    @IBOutlet private weak var highQualityCheckImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.goodQualityCheckImage = goodQualityCheckImage
        viewModel.highQualityView = highQualityView
        viewModel.highQualityCheckImage = highQualityCheckImage
        viewModel.goodQualityView = goodQualityView
        viewModel.selectGoodQaulityView()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func goodQualityButton(_ sender: UIButton) {
        viewModel.selectGoodQaulityView()
    }
    
    @IBAction func highQualityButton(_ sender: UIButton) {
        viewModel.selectHightQaulityView()
    }

}
