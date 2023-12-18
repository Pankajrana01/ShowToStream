//
//  User.swift
//  KarGoCustomer
//
//  Created by Applify on 22/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import CoreData

class User: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    var id: String = ""
    var accessToken: String = ""
    var loginType: LoginType = .email
    var facebookId: String = ""
    var appleId: String = ""
    var gmailId: String = ""
    var oauthToken: String = ""
    var firstName: String = ""
    var sessionId: String = ""
    var lastName: String = ""
    var fullName: String = ""
    var email: String = ""
    var password: String = ""
    var countryCode: String = ""
    var phoneNumber: String = ""
    var emailVerified: Bool = false
    var phoneVerified: Bool = false
    var profilePic: String = ""
    var profiles: [Profile] = []
    var becamePresenter = Int()
    var currencyRate : String = ""
    var currencyType : String = ""
    var socialId: String {
        switch loginType {
        case .apple:
            return self.appleId
        case .facebook:
            return self.facebookId
        case .google:
            return self.gmailId
        default:
            return ""
        }
    }

    override init() {
        
    }
    
    init(id: String,
         accessToken: String,
         loginType: LoginType,
         facebookId: String,
         appleId: String,
         gmailId: String,
         firstName: String,
         lastName: String,
         fullName:String,
         email: String,
         countryCode: String,
         phoneNumber: String,
         emailVerified: Bool,
         phoneVerified: Bool,
         sessionId: String,
         profilePic: String,
         profiles: [Profile],
         becamePresenter:Int,
         currencyRate : String,
         currencyType : String) {
        
        self.id = id
        self.accessToken = accessToken
        self.loginType = loginType
        self.facebookId = facebookId
        self.appleId = appleId
        self.gmailId = gmailId
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.email = email
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.emailVerified = emailVerified
        self.phoneVerified = phoneVerified
        self.sessionId = sessionId
        self.profilePic = profilePic
        self.profiles = profiles
        self.becamePresenter = becamePresenter
        self.currencyRate = currencyRate
        self.currencyType = currencyType
    }
        
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String

        let loginType = LoginType(rawValue: Int(aDecoder.decodeInt32(forKey: "loginType")))!
        let facebookId = aDecoder.decodeObject(forKey: "facebookId") as! String
        let appleId = aDecoder.decodeObject(forKey: "appleId") as! String
        let gmailId = aDecoder.decodeObject(forKey: "gmailId") as! String

        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let fullName = aDecoder.decodeObject(forKey: "fullName") as! String
        
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let countryCode = aDecoder.decodeObject(forKey: "countryCode") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String

        let emailVerified = aDecoder.decodeBool(forKey: "emailVerified")
        let phoneVerified = aDecoder.decodeBool(forKey: "phoneVerified")
        let sessionId = aDecoder.decodeObject(forKey: "sessionId") as? String ?? ""

        
        let profilePic = aDecoder.decodeObject(forKey: "profilePic") as! String
        let becamePresenter = Int(aDecoder.decodeInt32(forKey: "becamePresenter"))
        
        let currencyRate = aDecoder.decodeObject(forKey: "currencyRate") as? String ?? ""
        let currencyType = aDecoder.decodeObject(forKey: "currencyType") as? String ?? ""
        
        self.init(id: id,
                  accessToken: accessToken,
                  loginType: loginType,
                  facebookId: facebookId,
                  appleId: appleId,
                  gmailId: gmailId,
                  firstName: firstName,
                  lastName: lastName,
                  fullName: fullName,
                  email: email,
                  countryCode: countryCode,
                  phoneNumber: phoneNumber,
                  emailVerified: emailVerified,
                  phoneVerified: phoneVerified, sessionId: sessionId,
                  profilePic: profilePic,
                  profiles: KAPPSTORAGE.profiles,
                  becamePresenter: becamePresenter,
                  currencyRate : currencyRate,
                  currencyType:currencyType)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(accessToken, forKey: "accessToken")

        aCoder.encode(oauthToken, forKey: "oauthToken")
        aCoder.encode(loginType.rawValue, forKey: "loginType")
        aCoder.encode(facebookId, forKey: "facebookId")
        aCoder.encode(appleId, forKey: "appleId")
        aCoder.encode(gmailId, forKey: "gmailId")

        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(fullName, forKey: "fullName")
        
        aCoder.encode(email, forKey: "email")
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")

        aCoder.encode(emailVerified, forKey: "emailVerified")
        aCoder.encode(phoneVerified, forKey: "phoneVerified")

        aCoder.encode(sessionId, forKey: "sessionId")

        aCoder.encode(profilePic, forKey: "profilePic")
        aCoder.encode(becamePresenter, forKey: "becamePresenter")
        
        aCoder.encode(currencyRate, forKey: "currencyRate")
        aCoder.encode(currencyType, forKey: "currencyType")
        KAPPSTORAGE.profiles = profiles
    }

}

extension User {
    
    func hasImage() -> Bool {
        return !self.profilePic.isEmpty
    }
            
    var isEmailVerified: Bool {
        return emailVerified
    }

    var isProfileSetup: Bool {
        return phoneVerified
    }
    
    func updateProfiles(_ rawProfiles: [[String : Any]]) {
        var profiles = [Profile]()
        rawProfiles.forEach( { profiles.append(Profile(rawProfile: $0)) } )
        self.profiles = profiles
    }
    
    func updateWith(_ dic: [String: Any]) {
    
        if let currencyRate = dic[WebConstants.amount] as? NSNumber {
            self.currencyRate = "\(currencyRate)"
        }else{
            self.currencyRate = "0.0"
        }
        
        if let data = dic[WebConstants.currency] as? [String:Any] {
            if let currencyType = data[WebConstants.currency] {
                self.currencyType = "\(currencyType)"
            }
        }else{
            self.currencyType = ""
        }
    
        if let id = dic[WebConstants.id] {
            self.id = "\(id)"
        }
        
        if let accessToken = dic[WebConstants.accessToken] {
            self.accessToken = "\(accessToken)"
        }

        if let loginType = dic[WebConstants.loginType] {
            self.loginType = LoginType(rawValue: Int("\(loginType)")!)!
        }

        if let facebookId = dic[WebConstants.facebookId] {
            self.facebookId = "\(facebookId)"
        }
        
        if let appleId = dic[WebConstants.appleId] {
            self.appleId = "\(appleId)"
        }
        
        if let gmailId = dic[WebConstants.gmailId] {
            self.gmailId = "\(gmailId)"
        }

        if let firstName = dic[WebConstants.firstName] {
            self.firstName = "\(firstName)"
        }
        
        if let lastName = dic[WebConstants.lastName] {
            self.lastName = "\(lastName)"
        }
        
        if let fullName = dic[WebConstants.name] {
            self.fullName = "\(fullName)"
        }
        
        if let email = dic[WebConstants.email] {
            self.email = "\(email)"
        }
        
        if let phoneNumber = dic[WebConstants.phoneNumber] as? String {
            self.phoneNumber = phoneNumber.components(separatedBy: "-").last ?? ""
            self.countryCode = phoneNumber.components(separatedBy: "-").first ?? ""
        }
        
        if let emailVerified = dic[WebConstants.emailVerified] {
            self.emailVerified = "\(emailVerified)".boolValue
        }

        if let phoneVerified = dic[WebConstants.phoneVerified] {
            self.phoneVerified = "\(phoneVerified)".boolValue
        }
        
        if let sessionId = dic[WebConstants.sessionId] {
            self.sessionId = "\(sessionId)"
        }

        if let rawProfiles = dic[WebConstants.profiles] as? [[String: Any]] {
            updateProfiles(rawProfiles)
        }        
        
        if let becamePresenter = dic[WebConstants.becamePresenter] {
            self.becamePresenter = becamePresenter as! Int
        }
    }
    
}
