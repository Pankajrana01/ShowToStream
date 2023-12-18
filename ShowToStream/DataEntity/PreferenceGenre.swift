//
//  PreferenceGenre.swift
//  ShowToStream
//
//  Created by Applify on 16/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Foundation

class PreferenceGenre: NSObject, Codable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var _id: String
    var name: String
    
    init(id: String,
         name: String) {
        self._id = id
        self.name = name
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "_id")
        aCoder.encode(name, forKey: "name")
    }

    required convenience init(coder aDecoder: NSCoder) {
        let _id = aDecoder.decodeObject(forKey: "_id") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        
        self.init(id: _id,
                  name: name)
    }
    
    static func == (lhs: PreferenceGenre, rhs: PreferenceGenre) -> Bool {
        return lhs._id == rhs._id
    }

}
