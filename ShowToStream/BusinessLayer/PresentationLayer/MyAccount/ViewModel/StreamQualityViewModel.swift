//
//  StreamQualityViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 23/12/20.
//

import Foundation
import UIKit
class StreamQualityViewModel: BaseViewModel {
    
    var completionHandler: ((Bool) -> Void)?
    var goodQualityView: UIView!
    var goodQualityCheckImage: UIImageView!
    var highQualityView: UIView!
    var highQualityCheckImage: UIImageView!
    
    
    func selectGoodQaulityView(){
        self.goodQualityView.layer.borderWidth = 1
        self.goodQualityView.layer.borderColor = UIColor.appVoilet.cgColor
        self.highQualityView.layer.borderWidth = 1
        self.highQualityView.layer.borderColor = UIColor.appGray.cgColor
        self.goodQualityCheckImage.image = #imageLiteral(resourceName: "ic_checkbox_active")
        self.highQualityCheckImage.image = #imageLiteral(resourceName: "ic_checkbox")
    }
    
    func selectHightQaulityView(){
        self.goodQualityView.layer.borderWidth = 1
        self.goodQualityView.layer.borderColor = UIColor.appGray.cgColor
        self.highQualityView.layer.borderWidth = 1
        self.highQualityView.layer.borderColor = UIColor.appVoilet.cgColor
        self.goodQualityCheckImage.image = #imageLiteral(resourceName: "ic_checkbox")
        self.highQualityCheckImage.image = #imageLiteral(resourceName: "ic_checkbox_active")
    }
}
