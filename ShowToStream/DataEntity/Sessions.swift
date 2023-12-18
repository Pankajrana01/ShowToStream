//
//  Sessions.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 15/01/21.
//

import Foundation
import UIKit

class Sessions {
    var _id: String!
    var deviceName: String!
    var deviceType: String!
    
    init(_id: String, deviceName: String, deviceType: String) {
        self._id  = _id
        self.deviceName   = deviceName
        self.deviceType   = deviceType
    }
}

