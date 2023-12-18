//
//  Double.swift
//  ShowToStream
//
//  Created by Applify on 21/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Foundation

extension Double {
    var currencyAppended: String {
        return self.trailingZerosFixed.currencyAppended
    }

    var trailingZerosFixed: String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        if self == Double(Int(self)) {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        }
        return String(formatter.string(from: number) ?? "0")
    }
    
    
}
