//
//  WebPageViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 06/01/21.
//

import Foundation

class WebPageViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var titleName = ""
    var iscomeFrom = ""
    var url = ""
}
