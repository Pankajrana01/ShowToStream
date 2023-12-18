//
//  EarningsViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 30/12/20.
//

import UIKit

class EarningsViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.myAccount
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.earnings
    }
    
    lazy var viewModel: EarningsViewModel = EarningsViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var earningLabel: UILabel!
    @IBOutlet private weak var receivedLabel: UILabel!
    @IBOutlet private weak var pendingLabel: UILabel!
    @IBOutlet private weak var earnedCurrencylabel: UILabel!
    @IBOutlet private weak var receivedCurrencyLabel: UILabel!
    @IBOutlet private weak var pedningCurrecylabel: UILabel!
    
    
    override func viewDidLoad() {
        self.viewModel.tableView = tableView
        super.viewDidLoad()
        self.viewModel.earningLabel = earningLabel
        self.viewModel.receivedLabel = receivedLabel
        self.viewModel.pendingLabel = pendingLabel
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.stopPlayingTrailer, object: nil)
        self.viewModel.getEarningDetails()
        
        earnedCurrencylabel.text = "$"
        receivedCurrencyLabel.text = "$"
        pedningCurrecylabel.text = "$"
        
//        if viewModel.user.currencyRate != ""{
//            earnedCurrencylabel.text = "\(viewModel.user.currencyType)"
//            receivedCurrencyLabel.text = "\(viewModel.user.currencyType)"
//            pedningCurrecylabel.text = "\(viewModel.user.currencyType)"
//        }else{
//            earnedCurrencylabel.text =  "".currencyAppended
//            receivedCurrencyLabel.text = "".currencyAppended
//            pedningCurrecylabel.text = "".currencyAppended
//        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.backButtonTapped(sender)
    }
   
    @IBAction func accountButton(_ sender: UIButton) {
        showWorkInProgress()
    }
    
}
