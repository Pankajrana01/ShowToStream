//
//  RecentSearchCollectionViewCell.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 25/02/21.
//

import UIKit

class RecentSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var searchTitleLabel: UILabel!
    
    var recentSearch: String = "" { didSet { recentSearchDidSet() } }
    
    func recentSearchDidSet() {
        searchTitleLabel.text = recentSearch
    }
}
