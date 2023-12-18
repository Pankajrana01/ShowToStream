//
//  UIImageView.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import SDWebImage
import UIKit

extension UIImageView {
    func setImage(with urlString: String,
                  placeholderImage placeholder: UIImage?,
                  completed completedBlock: SDExternalCompletionBlock? = nil) {
        if urlString.isEmpty {
            self.image = placeholder
        } else if urlString.isLocalImageUrl {
            self.image = getImageFromTempDirectory(urlString) ?? placeholder
        } else {
            let url = URL(string: urlString)
            self.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: nil)
        }
    }

}
