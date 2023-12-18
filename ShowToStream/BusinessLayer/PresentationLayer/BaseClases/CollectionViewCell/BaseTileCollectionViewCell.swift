//
//  BaseTileCollectionViewCell.swift
//  ShowToStream
//
//  Created by Applify on 16/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class BaseTileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var headingLabel: UILabel!

    var title: String = ""                                      { didSet { updateView() } }
    var titleFont: UIFont = .appRegularFont(with: 14)           { didSet { updateView() } }
    var selectedTitleFont: UIFont = .appRegularFont(with: 14)   { didSet { updateView() } }

    var imageUrl: String = ""                                   { didSet { updateView() } }
    var image: UIImage? = nil                                   { didSet { updateView() } }

    var defaultBorderWidth: CGFloat = 1.0                       { didSet { updateView() } }
    var selectedBorderWidth: CGFloat = 1.0                      { didSet { updateView() } }

    var defaultCornerRadius: CGFloat = 6.0                      { didSet { updateView() } }
    var selectedCornerRadius: CGFloat = 6.0                     { didSet { updateView() } }

    var defaultBorderColor: UIColor? = nil                      { didSet { updateView() } }
    var selectedBorderColor: UIColor = .appVoiletBackground     { didSet { updateView() } }

    var defaultBackgroundColor: UIColor = .clear                { didSet { updateView() } }
    var selectedBackgroundColor: UIColor = .clear               { didSet { updateView() } }

    var defaultTileColor: UIColor = .black                      { didSet { updateView() } }
    var selectedTileColor: UIColor = .black                     { didSet { updateView() } }

    var tileSelected: Bool = false                              { didSet { updateView() } }

    func updateView() {
        headingLabel.text = title
        headingLabel.font = tileSelected ? selectedTitleFont : titleFont
        backgroundImageView.image = nil
        if !imageUrl.isEmpty {
            backgroundImageView.setImage(with: imageUrl, placeholderImage: nil)
        } else {
            backgroundImageView.image = image
        }
        headingLabel.textColor = tileSelected ? selectedTileColor : defaultTileColor
        containerView.backgroundColor = tileSelected ? selectedBackgroundColor : defaultBackgroundColor
        containerView.layer.borderColor = tileSelected ? selectedBorderColor.cgColor : defaultBorderColor?.cgColor
        containerView.layer.borderWidth = tileSelected ? selectedBorderWidth : defaultBorderWidth
        containerView.layer.cornerRadius = tileSelected ? selectedCornerRadius : defaultCornerRadius
        containerView.setNeedsDisplay()
    }
}
