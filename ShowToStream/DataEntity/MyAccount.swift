//
//  MyAccount.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 17/12/20.
//

import UIKit
class MyAccount {
    var image: UIImage!
    var name: String!
    var desc: String!
    init(name: String, image: UIImage, desc: String) {
        self.image  = image
        self.name   = name
        self.desc   = desc
    }
}

class BankAccounts {
    var _id: String!
    var accountNumber: String!
    var defaultBank: Bool!
    
    init(_id: String, accountNumber: String, defaultBank: Bool) {
        self._id  = _id
        self.accountNumber   = accountNumber
        self.defaultBank   = defaultBank
    }
}
