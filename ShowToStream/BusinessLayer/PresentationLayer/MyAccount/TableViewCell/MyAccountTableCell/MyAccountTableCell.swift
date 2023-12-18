//
//  MyAccountTableCell.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit

class MyAccountTableCell: UITableViewCell {
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var optionDesc: UILabel!
    @IBOutlet weak var TitleTopConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
