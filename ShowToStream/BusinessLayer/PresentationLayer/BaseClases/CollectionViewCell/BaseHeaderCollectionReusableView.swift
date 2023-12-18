//
//  BaseHeaderCollectionReusableView.swift
//  ShowToStream
//
//  Created by Applify on 17/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class BaseHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var rightButtonLabel: UILabel!

    var rightButtonTitle: String = ""                           { didSet { updateView() } }
    var title: String = ""                                      { didSet { updateView() } }
    var titleFont: UIFont = .appRegularFont(with: 14)           { didSet { updateView() } }

    var viewBackgroundColor: UIColor = .clear                   { didSet { updateView() } }

    var titleColor: UIColor = .black                            { didSet { updateView() } }
    var titleLeftPadding: CGFloat = 12                          { didSet { updateView() } }
    var lineHeight: CGFloat = 44                                { didSet { updateView() } }

    var rightButtonAction: (() -> Void)?
    class func sizeWith(title: String,
                        font: UIFont,
                        maxWidth: CGFloat,
                        lineHeight: CGFloat) -> CGSize {
        var size = title.size(with: font,
                              maxWidth: maxWidth,
                              lineHeight: lineHeight)
        size.height += 24
        return size
    }
    
    func updateView() {
        titleLabel.text                 = title
        titleLabel.font                 = titleFont
        titleLabel.lineHeight           = lineHeight
        titleLabel.textColor            = titleColor
        containerView.backgroundColor   = viewBackgroundColor
        titleLeadingConstraint.constant = titleLeftPadding
        
        rightButton.isHidden            = rightButtonTitle.isEmpty
        rightButtonLabel.text           = rightButtonTitle

    }

    @IBAction func rightButtonTapped(_ sender: Any?) {
        rightButtonAction?()
    }
}
