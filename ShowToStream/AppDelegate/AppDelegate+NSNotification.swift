//
//  AppDelegate+NSNotification.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let networkStatusUpdated    = Notification.Name("networkStatusUpdated")
    static let appEnterForeground      = Notification.Name("appEnterForeground")
    static let appBecomeInactive       = Notification.Name("appBecomeInactive")
    static let reloadShow              = Notification.Name("reloadShow")
    static let stopPlayingTrailer      = Notification.Name("stopPlayingTrailer")
    static let continuePlayingTrailer  = Notification.Name("continuePlayingTrailer")
    static let stopPlayingLiveVideo    = Notification.Name("stopPlayingLiveVideo")
    static let pipListner              = Notification.Name("pipListner")
    static let popThisViewController   = Notification.Name("popThisViewController")
}
