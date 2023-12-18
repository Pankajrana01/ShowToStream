//
//  PreferenceConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var preference: UIStoryboard {
        return UIStoryboard(name: "Preference", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let preference           = "PreferenceViewController"
}

extension CollectionViewCellIdentifier {
    static let categories           = "categories"
    static let genre                = "genre"
    static let preferenceHeader     = "preferenceHeader"
}

extension StringConstants {
    static let theatre              = "Theatre"
    static let cabaret              = "Cabaret"
    static let dance                = "Dance"
    static let comedy               = "Comedy"
    static let family               = "Family"
    static let studio               = "Studio"

    static let musicals             = "Musicals"
    static let plays                = "Plays"
    static let opera                = "Opera"
    static let magic                = "Magic"
    static let circus               = "Circus"
    static let standup              = "Standup"
    static let festivals            = "Festivals"
    static let classic              = "Classic"
    
    static let preferenceTitle      = "What do you\nlike to watch?"
    static let categoriesTitle      = "Select category"
    static let genreTitle           = "What you like"
}

extension ValidationError {
    static let emptyCategories      = "Please select Category"
    static let emptyGenre           = "Please select Genre"
}
