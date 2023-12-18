//
//  UserModel.swift
//  KarGoCustomer
//
//  Created by Applify on 23/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    static let shared = UserModel()
    var user: User = User()

    func refreshUser() {
        if let user = self.getLoggedInUserFromStorage() {
            self.user = user
        }
    }

    private override init() {
        super.init()
        if let user = self.getLoggedInUserFromStorage() {
            self.user = user
        }
    }

    private func getLoggedInUserFromStorage() -> User? {
        return KAPPSTORAGE.user
    }

    func setUserLoggedIn(_ isLoggedIn: Bool) {
        if isLoggedIn {
            KAPPSTORAGE.user = self.user
        } else {
            KAPPSTORAGE.user = nil
        }
    }
    
    func isLoggedIn() -> Bool {
        return KAPPSTORAGE.user != nil
    }

    func logoutUser() {
        switch user.loginType {
        case .facebook:
            FacebookLoginViewModel.logout { _ in
            }
        case .google:
            GoogleLoginViewModel.logout { _ in
            }
        default:
            break
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        KAPPSTORAGE.hasSetPreferences = false
//        KAPPSTORAGE.categories = []
//        KAPPSTORAGE.genres = []
        KAPPSTORAGE.user = nil

        self.user = User()
    }
    
    func addProfile(_ newProfile: Profile) {
        user.profiles.append(newProfile)
        KAPPSTORAGE.user = user
    }

    func updateProfile(_ newProfile: Profile) {
        if let index = user.profiles.firstIndex(where: { $0 == newProfile }) {
            user.profiles[index] = newProfile
        }
        KAPPSTORAGE.user = user
    }

    func updateProfiles(_ newProfiles: [[String: Any]]) {
        user.updateProfiles(newProfiles)
        KAPPSTORAGE.user = user
    }

    var authorizationToken: String {
        return "Bearer " + user.accessToken
    }
    
    var selectedProfileImage: UIImage {
        if isLoggedIn() {
            if user.profiles.count == 1{
                return user.profiles[0].avatarImage
            }else{
                return user.profiles[selectedProfileIndex].avatarImage
            }
           
        } else {
            return #imageLiteral(resourceName: "Avatar_1")
        }
    }
    
    var displaybleCategories: String {
        var newArray = [String]()
        selectedProfile.categories.forEach( { newArray.append($0.name) })
        selectedProfile.genres.forEach( { newArray.append($0.name) })
        if newArray.count < 3 {
            return newArray.joined(separator: "  •  ")
        } else {
            let moreCount = newArray.count - 2
            let string = "\(moreCount) more"
            newArray = [] + newArray[0...1  ] + [string]
        }
        return newArray.joined(separator: "  •  ")
    }

    var selectedProfileIndex: Int = 0
    
    var selectedProfile: Profile {
        if user.profiles.count == 1{
            return user.profiles[0]
        }else{
            return user.profiles[selectedProfileIndex]
        }
    }
}
