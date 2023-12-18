//
//  SearchedShowCollectionViewCell.swift
//  ShowToStream
//
//  Created by 1312 on 05/01/21.
//

import UIKit

class SearchedShowCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet private weak var watchNowView: UIView!
    @IBOutlet private weak var BuyToOwnPriceLabel: UILabel!
    @IBOutlet private weak var buyToOwnView: UIView!
    
    var show: Show! { didSet { showDidSet() } }
    var user = UserModel.shared.user
    func showDidSet() {
        if show.contentThumbnail != "" {
            posterImageView.setImage(with: show.contentThumbnail ?? "", placeholderImage: #imageLiteral(resourceName: "HomeLogo"))
        }
        showTitleLabel.text     = show.title
        producerLabel.text      = show.producer.first
        
        currencyConversion()
        isShowPurchased()
        
        watchNowView.layer.borderColor = UIColor.appSeparator.cgColor
        watchNowView.layer.borderWidth = 1.0
        buyToOwnView.layer.borderColor = UIColor.appSeparator.cgColor
        buyToOwnView.layer.borderWidth = 1.0
    }
    
    func currencyConversion(){
        if user.currencyRate != ""{
//            let price = SharedDataManager.shared.multiple(lhs: Double(show.payPerViewPrice ?? "0.0") ?? 0.0, rhs: Double(user.currencyRate) ?? 0.0)
//            print(round(price * 100) / 100.0)
//
//            priceLabel.text = "$ " + String(format: "%.2f", round(price * 100) / 100.0)
//
//            let ownBuyprice = SharedDataManager.shared.multiple(lhs: Double(show.buyToOwnPrice ?? "0.0") ?? 0.0, rhs: Double(user.currencyRate) ?? 0.0)
//            print(round(ownBuyprice * 100) / 100.0)
//            //viewModel.user.currencyType
//            BuyToOwnPriceLabel.text = "$ " + String(format: "%.2f", round(ownBuyprice * 100) / 100.0)
//
//        }else{
//            priceLabel.text = show.payPerViewPrice?.currencyAppended
//            BuyToOwnPriceLabel.text = show.buyToOwnPrice?.currencyAppended
//        }
        
        let strPayPerViewPrice = show.payPerViewPrice ?? "0"
        if (strPayPerViewPrice.contains(".0")) || strPayPerViewPrice.contains(".00") {
            let ppayPerViewPrice = SharedDataManager.shared.multiple(lhs: Double(show.payPerViewPrice ?? "0.0") ?? 0.0, rhs: Double(user.currencyRate) ?? 0.0)
            print(round(ppayPerViewPrice * 100) / 100.0)
            //viewModel.user.currencyType
            priceLabel.text = "$ " + String(format: "%.2f", round(ppayPerViewPrice * 100) / 100.0)
        } else {
            priceLabel.text = "$ " + strPayPerViewPrice
        }
        
        
        let strBuyToOwnPrice = show.buyToOwnPrice ?? "0"
        if (strBuyToOwnPrice.contains(".0")) || strBuyToOwnPrice.contains(".00") {
            let ownBuyprice = SharedDataManager.shared.multiple(lhs: Double(show.buyToOwnPrice ?? "0.0") ?? 0.0, rhs: Double(user.currencyRate) ?? 0.0)
            print(round(ownBuyprice * 100) / 100.0)
            //viewModel.user.currencyType
            BuyToOwnPriceLabel.text = "$ " + String(format: "%.2f", round(ownBuyprice * 100) / 100.0)
        } else {
            BuyToOwnPriceLabel.text = "$ " + strBuyToOwnPrice
        }
    } else{
        priceLabel.text = show.payPerViewPrice?.currencyAppended
        BuyToOwnPriceLabel.text = show.buyToOwnPrice?.currencyAppended
    }
    
    
    }
    
    func isShowPurchased(){
        if show.isPurchased {
            if show.paymentType == "2"{
                watchNowView.isHidden = true
                buyToOwnView.isHidden = true
            } else {
                watchNowView.isHidden = true
                if show.buyToOwnStatus{
                    buyToOwnView.isHidden = false
                }else {
                    buyToOwnView.isHidden = true
                }
            }
        } else {
            watchNowView.isHidden = false
            if show.buyToOwnStatus{
                buyToOwnView.isHidden = false
            }else {
                buyToOwnView.isHidden = true
            }
        }
    }
    
   
}
