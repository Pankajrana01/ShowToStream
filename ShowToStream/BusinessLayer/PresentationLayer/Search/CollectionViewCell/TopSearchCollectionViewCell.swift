//
//  TopSearchCollectionViewCell.swift
//  ShowToStream
//
//  Created by 1312 on 05/01/21.
//

import UIKit

class TopSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var searchTitleLabel: UILabel!
    
    var topSearch: String = "" { didSet { topSearchDidSet() } }
    
    func topSearchDidSet() {
        searchTitleLabel.text = topSearch
    }
    
}
