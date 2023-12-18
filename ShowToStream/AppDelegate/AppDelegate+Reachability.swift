//
//  AppDelegate+Reachability.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Alamofire

extension AppDelegate {
    func startListeningNetworkReachability() {
        if let manager = NetworkReachabilityManager() {
            manager.startListening { status in
                NotificationCenter.default.post(name: .networkStatusUpdated,
                                                object: manager.isReachable)
                
                if manager.isReachable {
                    self.loadData { urls in }
                }
            }
        }
    }
}
