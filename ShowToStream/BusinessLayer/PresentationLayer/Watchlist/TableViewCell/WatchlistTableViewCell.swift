//
//  WatchlistTableViewCell.swift
//  ShowToStream
//
//  Created by 1312 on 04/01/21.
//

import SwipeCellKit
import UIKit

class WatchlistTableViewCell: SwipeTableViewCell     {
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
            posterImageView.setImage(with: show.contentThumbnail ?? "", placeholderImage: #imageLiteral(resourceName: "Home"))
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
//            //\(user.currencyType)
//            priceLabel.text = "$ " + String(format: "%.2f", round(price * 100) / 100.0)
//
//            let ownBuyprice = SharedDataManager.shared.multiple(lhs: Double(show.buyToOwnPrice ?? "0.0") ?? 0.0, rhs: Double(user.currencyRate) ?? 0.0)
//            print(round(ownBuyprice * 100) / 100.0)
//            //viewModel.user.currencyType
//            BuyToOwnPriceLabel.text = "$ " + String(format: "%.2f", round(ownBuyprice * 100) / 100.0)
            
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
            if show.paymentType == "2" {
                buyToOwnView.isHidden = true
                watchNowView.isHidden = true
            } else {
                watchNowView.isHidden = true
                if show.buyToOwnStatus == true{
                    buyToOwnView.isHidden = false
                } else {
                    buyToOwnView.isHidden = true
                }
            }
        } else {
            if show.buyToOwnStatus == true{
                buyToOwnView.isHidden = false
            } else {
                buyToOwnView.isHidden = true
            }
            if show.payPerViewStatus == true{
                watchNowView.isHidden = false
            } else {
                watchNowView.isHidden = true
            }
        }
        
        
//        if show.buyToOwnStatus{
//            buyToOwnView.isHidden = false
//        }else {
//            buyToOwnView.isHidden = true
//        }
    }
}
//if (mDataSet?.get(position)?.isPurchased!!) {
//    if (mDataSet?.get(position)?.paymentType == "2") {
//        holder.itemView.llBuy.visibility = View.GONE
//        holder.itemView.llPayPerView.visibility = View.GONE
//    } else {
//        holder.itemView.llPayPerView.visibility = View.GONE
//        if (mDataSet?.get(position)?.contentId!!.buyToOwnStatus) {
//            holder.itemView.tvBuyPrice.text =
//                getLocalCurrencyPrice(mDataSet?.get(position)?.contentId!!.buyToOwnPrice)
//            holder.itemView.llBuy.visibility = View.VISIBLE
//        } else {
//            holder.itemView.llBuy.visibility = View.GONE
//        }
//    }
//} else {
//    if (mDataSet?.get(position)?.contentId!!.buyToOwnStatus) {
//        holder.itemView.tvBuyPrice.text =
//            getLocalCurrencyPrice(mDataSet?.get(position)?.contentId!!.buyToOwnPrice)
//        holder.itemView.llBuy.visibility = View.VISIBLE
//    } else {
//        holder.itemView.llBuy.visibility = View.GONE
//    }
//
//    if (mDataSet?.get(position)?.contentId!!.payPerViewStatus) {
//        holder.itemView.tvSearchPrice.text =
//            getLocalCurrencyPrice(mDataSet?.get(position)?.contentId!!.payPerViewPrice)
//        holder.itemView.llPayPerView.visibility = View.VISIBLE
//    } else {
//        holder.itemView.llPayPerView.visibility = View.GONE
//    }
//}
