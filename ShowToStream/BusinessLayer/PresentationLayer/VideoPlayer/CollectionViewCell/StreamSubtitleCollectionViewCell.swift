//
//  StreamSubtitleCollectionViewCell.swift
//  ShowToStream
//
//  Created by 1312 on 30/12/20.
//

import UIKit

class StreamSubtitleCollectionViewCell: UICollectionViewCell {

    var subtitle: StreamSubtitle! { didSet { subtitleDidSet() } }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var checkboxImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func subtitleDidSet() {
        containerView.backgroundColor = subtitle.isSelected ? UIColor.appContainerViewBackgroud : .clear
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = subtitle.isSelected ? UIColor.appVoilet.cgColor : UIColor.clear.cgColor
        checkboxImageView.image = subtitle.isSelected ? #imageLiteral(resourceName: "ic_checkbox_active") : #imageLiteral(resourceName: "ic_checkbox")
        nameLabel.text = subtitle.name
        nameLabel.font = subtitle.isSelected ? .appBoldFont(with: 14) : .appMediumFont(with: 14)
    }

}
