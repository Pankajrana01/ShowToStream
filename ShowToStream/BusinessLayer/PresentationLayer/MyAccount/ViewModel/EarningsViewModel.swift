//
//  EarningsViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 30/12/20.
//

import Foundation
import UIKit
import SwipeCellKit
class EarningsViewModel : BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var earningLabel: UILabel!
    var receivedLabel: UILabel!
    var pendingLabel: UILabel!
    var bankAccountsData = [BankAccounts]()
    var defaultAccount = [Int]()
    var user = KUSERMODEL.user
    weak var tableView: UITableView! { didSet { configureTableView() } }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.accountDetailTableCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.accountDetailTableCell)
        
    }
    
    func getEarningDetails(){
        processDataForGetEarningDetail()
        processDataForGetAccountDetail()
    }
    
}
extension EarningsViewModel {
    //MARK:- API Call...
    func processDataForGetEarningDetail() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.MyAccount.presenterEarningDetails,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
//                                    if let passbook = responseData[WebConstants.passbook] as? [String:Any]{
//                                        self.earningLabel.text = "\(passbook[WebConstants.earnedAmount] as? NSNumber ?? 0)"
//                                        self.receivedLabel.text = "\(passbook[WebConstants.receivedAmount] as? NSNumber ?? 0)"
//                                        self.pendingLabel.text = "\(passbook[WebConstants.pendingAmount] as? NSNumber ?? 0)"
//                                    }
                                    
                                    let dataDict = response?[APIConstants.data] as! NSDictionary
                                    let earned = dataDict["earned"] as? Double
                                    let stripeFee = dataDict["stripeFee"] as? Double
                                    let requiredEarning = (Double(earned ?? Double(0.0)) - (Double((stripeFee ?? Double(0.0))) / Double(100.0)))
                                    let strReqEarning = "\(requiredEarning)"
                                    if strReqEarning.contains(".0") || strReqEarning.contains(".00") {
                                        self.earningLabel.text = "\(Int(requiredEarning))"
                                    } else {
                                        self.earningLabel.text = "\(requiredEarning)"
                                    }
                                    //self.earningLabel.text = "\(requiredEarning)"
                                }
                                hideLoader()
        }
    }
    
    func processDataForGetAccountDetail() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.MyAccount.bankAccountDetails,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let responseData = response![APIConstants.data] as? [[String: Any]] {
                                        self.defaultAccount = [Int]()
                                        self.handleAccountsData(data: responseData)
                                    }
                                }
                                hideLoader()
        }
    }
    
    func handleAccountsData(data:[[String: Any]]){
        self.bankAccountsData.removeAll()
        for rawObject in data {
            let detail = rawObject 
            self.bankAccountsData.append(BankAccounts(_id: detail[WebConstants.id] as? String ?? "", accountNumber: detail[WebConstants.accountNumber] as? String ?? "", defaultBank: detail[WebConstants.defaultBank] as? Bool ?? false))
            
        }
        if self.tableView != nil { self.tableView.reloadData() }
    }
    
    func processDataForRemoveAccountFromList(index:Int, params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.bankAccountDetails,
                               params: params,
                               headers: headers,
                               method: .delete) { response, _ in
                                if !self.hasErrorIn(response) {
                                    showMessage(with: StringConstants.accountRemove)
                                    self.bankAccountsData.remove(at: index)
                                    self.tableView.reloadData()
                                }
                                hideLoader()
        }
    }
    
    func processDataForSetDefaultAccountFromList(index:Int, params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.bankAccountDefault,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    self.processDataForGetAccountDetail()
                                }
                                hideLoader()
        }
    }
}

extension EarningsViewModel : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bankAccountsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.accountDetailTableCell) as? AccountDetailTableCell{
            cell.accounts = self.bankAccountsData[indexPath.row]
            cell.delegate = self
            cell.setDefaultAccount.tag = indexPath.row
            
            if self.bankAccountsData[indexPath.row].defaultBank == true{
                self.defaultAccount.append(1)
            }else{
                self.defaultAccount.append(0)
            }
            
            cell.setDefaultAccount.addTarget(self, action: #selector(setDefault(sender:)), for: .touchUpInside)

            return cell
        }
        return UITableViewCell()
    }
    
    @objc func setDefault(sender: UIButton){
        let buttonTag = sender.tag
        var setDefault = ""
        if defaultAccount[buttonTag] == 1{
            setDefault = "0"
        }else{
            setDefault = "1"
            let params: [String: Any] = [WebConstants.accountId: self.bankAccountsData[buttonTag]._id!,
                                         WebConstants.defaultBank: setDefault]
            
            self.processDataForSetDefaultAccountFromList(index: buttonTag, params: params)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
extension EarningsViewModel: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .border
        
        return options
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: StringConstants.remove) { action, indexPath in
            
            if self.bankAccountsData[indexPath.row].defaultBank == true{
                if self.bankAccountsData.count > 1{
                    showMessage(with: StringConstants.selectAnotherAccount, theme: .error)
                }
            }else{
                if self.bankAccountsData.count > 1{
                    let alert = UIAlertController(title: StringConstants.removeWatchlistConfirm, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: StringConstants.remove, style: .destructive)  { _ in
                        self.deleteAccount(indexPath: indexPath)
                        
                        // tableView.deleteRows(at: [indexPath], with: .automatic)
                    })
                    
                    alert.addAction(UIAlertAction(title: StringConstants.no, style: .default, handler: nil))
                    self.hostViewController.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = #imageLiteral(resourceName: "Remove")
        
        return [deleteAction]
    }
    
    
//    if user delete default one then another  or last one should be automatically make default bank accounts.
    
    func deleteAccount(indexPath:IndexPath){
        // default account not to delete
        if self.bankAccountsData[indexPath.row].defaultBank == false{
            let params: [String: Any] = [WebConstants.accountId: self.bankAccountsData[indexPath.row]._id!]
            self.processDataForRemoveAccountFromList(index: indexPath.row, params: params)
        }
        
    }
}

