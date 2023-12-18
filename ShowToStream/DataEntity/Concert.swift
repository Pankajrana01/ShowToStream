//
//  Concert.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 03/02/21.
//

import Foundation

class Concert: NSObject {
    var title: String
    var show: [Show]
    init(title: String, show: [Show]) {
        self.title = title
        self.show = show
    }
}
