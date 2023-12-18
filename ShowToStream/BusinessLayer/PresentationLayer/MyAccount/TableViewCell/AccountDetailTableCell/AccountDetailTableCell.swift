//
//  AccountDetailTableCell.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 18/03/21.
//

import UIKit
import SwipeCellKit
class AccountDetailTableCell: SwipeTableViewCell {
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var setDefaultAccount: UIButton!
    
    var accounts: BankAccounts! { didSet { dataDidSet() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func dataDidSet(){
        accountNumber.text = accounts.accountNumber
        if accounts.defaultBank == true{
            setDefaultAccount.setImage(#imageLiteral(resourceName: "ic_checkbox_active2"), for: .normal)
            setDefaultAccount.setTitle(WebConstants.defaultforPayments, for: .normal)
        }else{
            setDefaultAccount.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
            setDefaultAccount.setTitle(WebConstants.defaultforPayments, for: .normal)
        }
    }
}
