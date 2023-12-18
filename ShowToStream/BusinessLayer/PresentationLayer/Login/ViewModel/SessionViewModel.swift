//
//  SessionViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 15/01/21.
//

import Foundation
import UIKit
class SessionViewModel: BaseViewModel {
    var session = [Sessions]()
    
    var completionHandler: ((String) -> Void)?
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
    
    var containerViewHeight = NSLayoutConstraint()
    
    var selectedSession = -1
    
    var selectedSessionId = ""
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: TableViewNibIdentifier.sessionTableViewCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.sessionTableViewCell)
        
    }
    
    override func viewLoaded() {
        super.viewLoaded()
       
    }
}

extension SessionViewModel : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.sessionTableViewCell) as? SessionTableViewCell{
            
            if indexPath.row == session.endIndex {
                cell.confrimButton.isHidden = false
                cell.confrimButton.addTarget(self, action: #selector(confirm(sender:)), for: .touchUpInside)

            }else{
                cell.sessionName.text = session[indexPath.row].deviceName
                cell.confrimButton.isHidden = true
                cell.bgView.layer.borderWidth = 1
                cell.bgView.layer.borderColor = UIColor.appGray.cgColor
                if self.selectedSession == indexPath.row{
                    cell.selectImage.image = #imageLiteral(resourceName: "ic_checkbox_active")
                }else{
                    cell.selectImage.image = #imageLiteral(resourceName: "ic_checkbox")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func confirm(sender: UIButton){
       print("button tapped")
        self.completionHandler?(self.selectedSessionId)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= session.count{
         self.selectedSession = indexPath.row
         self.selectedSessionId = session[indexPath.row]._id
         self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}

