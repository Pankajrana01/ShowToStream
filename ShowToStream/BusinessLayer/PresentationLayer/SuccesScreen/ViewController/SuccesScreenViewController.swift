//
//  SuccesScreenViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 23/12/20.
//

import UIKit

class SuccesScreenViewController: BaseAlertViewController {
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.succesScreen
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.succesScreen
    }
    lazy var viewModel: SuccesScreenViewModel = SuccesScreenViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((Bool) -> Void)) {
        let controller = self.getController() as! SuccesScreenViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    func show(over host: UIViewController,
              completionHandler: @escaping ((Bool) -> Void)) {
        self.viewModel.completionHandler = completionHandler
        self.show(over: host)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delay(4.0){
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss()
    }
    

   

}
