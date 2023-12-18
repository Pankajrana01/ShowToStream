//
//  GlobalConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Foundation
import UIKit

let KAPPDELEGATE                        = AppDelegate.shared

let KAPPSTORAGE                         = AppStorage.shared

let KUSERMODEL                          = UserModel.shared

let DEVICENAME                          =  "\(UIDevice().type) " + "(\(UIDevice.current.name))"

let APPNAME                             = "Show To Stream"

let DefaultSelectedCountryCode          = "+61"

let TrailerPlayDelay: TimeInterval      = 4

//let GoogleSignInApiKey = "1009047242851-j9qju63k6i4e5luctgpav8m7qje396cr.apps.googleusercontent.com"
let GoogleSignInApiKey = "371965977266-jfoupk6nsid4ocn1sqsafh6igfibo1ai.apps.googleusercontent.com"


//--In-app purchase products ids
let INAPP_PRODUCTIDs = ["com.sts.show.purchase"]

struct ViewControllerIdentifier {
}

struct TableViewCellIdentifier {
}

struct TableViewNibIdentifier {
}

struct CollectionViewCellIdentifier {
}

struct ValidationError {
}

struct SucessMessage {
}

struct CharacterLimit {
}

struct StringConstants {
}

struct NibCellIdentifier {
}
struct PageLimit {
    static let defaultLimit = 20
    static let danceListingLimit = 5
}

struct WebConstants {
    static let user                             = "USER"
    static let limit                            = "limit"
    static let skip                             = "skip"
    static let firstName                        = "firstName"
    static let lastName                         = "lastName"
    static let email                            = "email"
    static let emailOrPhoneNumber               = "emailOrPhoneNumber"
    static let password                         = "password"
    static let name                             = "name"
    static let url                              = "url"
    static let authorization                    = "authorization"
    static let accountNumber                    = "accountNumber"
    static let accountId                        = "accountId"
    static let defaultBank                      = "defaultBank"
    static let passbook                         = "passbook"
    static let earnedAmount                     = "earnedAmount"
    static let receivedAmount                   = "receivedAmount"
    static let pendingAmount                    = "pendingAmount"
    static let responseType                     = "responseType"
    static let watchListAlreadyExit             = "WATCHLIST_ALREADY_EXIST"
    static let platform                         = "platform"
    static let tvCode                           = "tvCode"
    static let deviceToken                      = "deviceToken"
    static let deviceName                       = "deviceName"
    static let deviceType                       = "deviceType"
    static let sessionId                        = "sessionId"
    static let phoneNumber                      = "phoneNumber"
    static let companyName                      = "companyName"
    static let message                          = "message"
    static let oldPassword                      = "oldPassword"
    static let newPassword                      = "newPassword"
    static let id                               = "_id"
    static let sequenceContentId                = "sequenceContentId"
    static let timeleft                         = "timeLeft"
    static let contentId                        = "contentId"
    static let clapOrNot                        = "clapOrNot"
    static let ovationOrNot                     = "ovationOrNot"
    static let contentDetails                   = "contentDetails"
    static let concert                          = "concert"
    static let profileId                        = "profileId"
    static let reason                           = "reason"
    static let amount                           = "amount"
    static let currency                         = "currency"
    static let defaultforPayments               = "  Default for payments"
    static let accessToken                      = "accessToken"
    static let addtoWatchlist                   = "Add to Watchlist"
    static let addedtoWatchlist                 = "Added to Watchlist"
    static let socialId                         = "socialId"
    static let userCountry                      = "userCountry"
    static let loginType                        = "loginType"
    static let facebookId                       = "facebookId"
    static let appleId                          = "appleId"
    static let gmailId                          = "gmailId"
    static let oauthToken                       = "oauthToken"
    static let token                            = "token"
    static let danceStudioCode                  = "danceStudioCode"
    static let image                            = "image"
    static let landscape                        = "landscape"
    static let portrait                         = "portrait"
    static let directory                        = "directory"
    static let referredBy                       = "referredBy"
    static let emailVerified                    = "emailVerified"
    static let phoneVerified                    = "phoneVerified"
    static let profilePic                       = "profilePic"
    static let title                            = "title"
    static let trailerFile                      = "trailerFile"
    static let streamFile                       = "streamFile"
    static let subtitle                         = "subtitle"
    static let keyword                          = "keyword"
    static let profiles                         = "profiles"
    static let profileImage                     = "profileImage"
    static let profileName                      = "profileName"
    static let emailAlreadyVerified             = "EMAIL_ALREADY_VERIFIED"
    static let contentThumbnail                 = "contentThumbnail"
    static let categoryIds                      = "categoryIds"
    static let categoryId                       = "categoryId"
    static let genreIds                         = "genreIds"
    static let contentDescription               = "description"
    static let playDuration                     = "playDuration"
    static let timeLeft                         = "timeLeft"
    static let payPerViewPrice                  = "payPerViewPrice"
    static let buyToOwnPrice                    = "buyToOwnPrice"
    static let buyToOwnStatus                   = "buyToOwnStatus"
    static let payPerViewStatus                 = "payPerViewStatus"
    static let paymentType                      = "paymentType"
    static let applause                         = "applause"
    static let isApplause                       = "isApplause"
    static let isStandingOvation                = "isStandingOvation"
    static let isDanceStudioPrivate             = "isDanceStudioPrivate"
    static let standingOvation                  = "standingOvation"
    static let inWatchList                      = "inWatchList"
    static let isPurchased                      = "isPurchased"
    static let trending                         = "trending"
    static let casting                          = "casting"
    static let categories                       = "categories"
    static let genres                           = "genres"
    static let role                             = "role"
    static let director                         = "Director"
    static let actor                            = "Actor"
    static let kids                            = "KIDS"
    static let writer                            = "Writer"
    static let producer                         = "Producer"
    static let becamePresenter                  = "becamePresenter"
    static let createProfile                    = "createProfile"
    static let logoutMesaage                    = "Your login session has been expired, please login again to continue."
    static let continueWatching                 = "Continue Watching"
    // dummy video URL ...pankajrana
    static let forBiggerJoyrides                = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
    
    static let bigBuckBunny                     = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    // dummy show name ...pankajrana
    static let theNutcracker                     = "The Nutcracker"
    static let theSleepingBeauty                 = "The Sleeping Beauty"
    static let new                               = "NEW"
    static let popular                           = "POPULAR"
    static let showDesc                          = "Description"
    static let showSubTitle                      = "Subtitle"
    static let reqShowDesc                       = "Other Information"
    static let reqShowSubTitle                   = "Overview"

}


let characters = [Character(id: 1, image: #imageLiteral(resourceName: "Avatar_1")),
                  Character(id: 2, image: #imageLiteral(resourceName: "Avatar_2")),
                  Character(id: 3, image: #imageLiteral(resourceName: "Avatar_3")),
                  Character(id: 4, image: #imageLiteral(resourceName: "Avatar_4")),
                  Character(id: 5, image: #imageLiteral(resourceName: "Avatar_5")),
                  Character(id: 6, image: #imageLiteral(resourceName: "Avatar_6")),
                  Character(id: 7, image: #imageLiteral(resourceName: "Avatar_7")),
                  Character(id: 8, image: #imageLiteral(resourceName: "Avatar_8")),
                  Character(id: 9, image: #imageLiteral(resourceName: "Avatar_9")),
                  Character(id: 10, image: #imageLiteral(resourceName: "Avatar_10")),
                  Character(id: 11, image: #imageLiteral(resourceName: "Avatar_11")),
                  Character(id: 12, image: #imageLiteral(resourceName: "Avatar_12")),
                  Character(id: 13, image: #imageLiteral(resourceName: "Avatar_13")),
                  Character(id: 14, image: #imageLiteral(resourceName: "Avatar_14")),
                  Character(id: 15, image: #imageLiteral(resourceName: "Avatar_15")),
                  Character(id: 16, image: #imageLiteral(resourceName: "Avatar_16")),
                  Character(id: 17, image: #imageLiteral(resourceName: "Avatar_17")),
                  Character(id: 18, image: #imageLiteral(resourceName: "Avatar_18")),
                  Character(id: 19, image: #imageLiteral(resourceName: "Avatar_19")),
                  Character(id: 20, image: #imageLiteral(resourceName: "Avatar_20")),
                  Character(id: 21, image: #imageLiteral(resourceName: "Avatar_21")),
                  Character(id: 22, image: #imageLiteral(resourceName: "Avatar_22")),
                  Character(id: 23, image: #imageLiteral(resourceName: "Avatar_23")),
                  Character(id: 24, image: #imageLiteral(resourceName: "Avatar_24")),
                  Character(id: 25, image: #imageLiteral(resourceName: "Avatar_25"))]


enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}
