//
//  SessionTableViewCell.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 15/01/21.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var confrimButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
