//
//  ViewMoreCollectionViewCell.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 05/02/21.
//

import UIKit

class ViewMoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewMoreView: UIView! { didSet { configureCollectionView() } }
    @IBOutlet weak var viewMoreViewConcert: UIView! { didSet { configureCollectionViewForCencert() } }
    
    @IBOutlet weak var viewMoreWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewMoreHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var viewMoreCencertWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewMoreCencertHeightConstraints: NSLayoutConstraint!
    
    func configureCollectionView(){
        viewMoreView.layer.borderColor = UIColor.appGray.cgColor
        viewMoreView.layer.borderWidth = 1
        viewMoreView.clipsToBounds = true

    }
    
    func configureCollectionViewForCencert(){
        viewMoreViewConcert.layer.borderColor = UIColor.appGray.cgColor
        viewMoreViewConcert.layer.borderWidth = 1
        viewMoreViewConcert.clipsToBounds = true

    }
}
