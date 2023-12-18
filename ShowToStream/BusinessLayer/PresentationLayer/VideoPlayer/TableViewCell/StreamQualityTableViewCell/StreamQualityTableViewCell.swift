//
//  StreamQualityTableViewCell.swift
//  ShowToStream
//
//  Created by 1312 on 30/12/20.
//

import UIKit

class StreamQualityTableViewCell: UITableViewCell {
    
    var streamQuality: StreamQuality! { didSet { streamQualitydidSet() } }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var checkboxImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func streamQualitydidSet() {
        containerView.backgroundColor = streamQuality.isSelected ? UIColor.appContainerViewBackgroud : .clear
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = streamQuality.isSelected ? UIColor.appVoilet.cgColor : UIColor.clear.cgColor
        checkboxImageView.image = streamQuality.isSelected ? #imageLiteral(resourceName: "ic_checkbox_active") : #imageLiteral(resourceName: "ic_checkbox")
        nameLabel.text = streamQuality.name
        nameLabel.font = streamQuality.isSelected ? .appBoldFont(with: 14) : .appMediumFont(with: 14)
    }
}
