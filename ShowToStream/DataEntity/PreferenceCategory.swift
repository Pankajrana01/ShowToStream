//
//  PreferenceCategory.swift
//  ShowToStream
//
//  Created by Applify on 16/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class PreferenceCategory: NSObject, Codable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    var _id: String
    var name: String
    var image: String
    
    init(id: String,
         name: String,
         image: String) {
        self._id = id
        self.name = name
        self.image = image
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }

    required convenience init(coder aDecoder: NSCoder) {
        let _id = aDecoder.decodeObject(forKey: "_id") as! String
        let image = aDecoder.decodeObject(forKey: "image") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        
        self.init(id: _id,
                  name: name,
                  image: image)
    }

    static func == (lhs: PreferenceCategory, rhs: PreferenceCategory) -> Bool {
        return lhs._id == rhs._id
    }

}
