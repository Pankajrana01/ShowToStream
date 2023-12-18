//
//  WebConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class GeneralAPiResponse: Codable {
    var statusCode: Int
    var message: String
    
    private enum CodingKeys: String, CodingKey { case statusCode, message }
            
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
        message = try container.decode(String.self, forKey: .message)
    }
}

struct APIConstants {
    static let code = "statusCode"
    static let response = "response"
    static let data = "data"
    static let message = "message"
    static let pageNumber = "page_number"
    static let responseType = "responseType"
    static let sessions = "sessions"
    static let status = "statusCode"
}

struct GenericErrorMessages {
    static let internalServerError = "Something went wrong. Try again."
    static let noInternet = "No internet connection."
}


struct APIUrl {
    static let host = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
    static var baseUrl: String {
        return host + "api/"
    }

    static let googleServicesBaseUrl = "https://maps.googleapis.com/maps/api/"

    struct GoogleApiUrls {
        static let autoCompleteUrl = "place/autocomplete/json"
        static let placeDetail = "place/details/json"
    }

    struct GeneralUrls {
        static let termsAndConditions = "https://www.google.com"
        static let privacyPolicy = "https://www.google.com"
        static let faqs = "https://api.showtostream.com/api/user/faqs"
        static let aboutUs = "https://api.showtostream.com/api/user/about-us"
        static let legal = "https://api.showtostream.com/api/user/legal"
    }
    
    struct BasicApis {
        private static let basePreFix   = baseUrl       + "common/"
        static let uploadImage          = basePreFix    + "upload"
        static let getS3Floders         = basePreFix    + "getS3Folders"
        
    }
    
    struct User {
        static let basePreFix           = baseUrl       + "user"
    }
    
    struct UserApis {
        private static let basePreFix   = baseUrl       + "user/"
        static let register             = basePreFix    + "register"
        static let login                = basePreFix    + "login"
        static let socialLogin          = basePreFix    + "oauth/login"
        static let socialRegister       = basePreFix    + "oauth/register"
        static let updateUser           = basePreFix    + "updateUser"
        static let forgotPassword       = basePreFix    + "forgotPassword"
        static let resetPassword        = basePreFix    + "resetPassword"
        static let changePassword       = basePreFix    + "changePassword"
        static let logout               = basePreFix    + "logout"
        static let commonUrl            = basePreFix    + "commonUrls"
        static let contact              = basePreFix    + "contact"
    }
    
    struct OTPApis {
        private static let basePreFix   = baseUrl       + "user/"
        static let generateOTP          = basePreFix    + "generateOTP"
        static let verifyOTP            = basePreFix    + "verifyOTP"
        static let verifyEmail          = basePreFix    + "verifyEmail"
        static let resendVerifyEmail    = basePreFix    + "resendVerifyEmail"
    }
    
    struct AuthenticationApis {
        static let validateEmail = "users/validateEmail"
        static let signUp = "users/signUp"
        static let login = "users/login"
        static let logout = "users/logout"
        static let accessTokenLogin = "users/accessTokenLogin"
        static let verifyEmailOTP = "users/sendVerifyEmailCode"
        static let verifyEmail = "users/matchVerifyEmailCode"
        static let changePassword = "users/changePassword"
        static let setNotificationStatus = "users/setNotificationStatus"
    }

    struct ResetPassword {
        static let validate = "users/sendResetPasswordCode"
        static let otpVerify = "users/matchResetPasswordCode"
        static let resetPassword = "users/resetPassword"
    }

    struct CreateProfile {
        static let create = "users/createProfile"
        static let edit = "users/editProfile"
    }

    struct Preference {
        private static let basePreFix        = baseUrl       + "common/"
        static let categories                = basePreFix    + "categories"
        static let genres                    = basePreFix    + "genres"
    }

    struct MyAccount {
        private static let basePreFix         = baseUrl       + "user/"
        static let contentReport              = basePreFix    + "contentReport"
        static let changePassword             = basePreFix    + "changePassword"
        static let logout                     = basePreFix    + "logout"
        static let profile                    = basePreFix    + "profile"
        static let selectProfile              = basePreFix    + "profile/select"
        static let preferences                = basePreFix    + "profile/preference"
        static let playOnTV                   = basePreFix    + "playOnTV"
        static let becomeAPresenter           = basePreFix    + "becomeAPresenter"
        static let presenterEarnings          = basePreFix    + "presenterEarnings"
        static let searchKeyword              = basePreFix    + "searchKeyword"
        static let presenterEarningDetails    = basePreFix    + "presenterEarningDetails"
        static let bankAccountDetails         = basePreFix    + "presenter/bankAccount"
        static let bankAccountDefault         = basePreFix    + "presenter/bankAccountDefault"
    }
    
    struct HomeCommon {
        private static let basePreFix          = baseUrl       + "common/"
        static let getRecommendedContent       = basePreFix    + "getRecommendedContent"
        static let popular                     = basePreFix    + "popular"
        static let topten                      = basePreFix    + "topten"
        static let contentDetails              = basePreFix    + "contentDetails"
        static let danceConcert                = basePreFix    + "dance"
        static let mayLikeVideos               = basePreFix    + "mayLikeVideos"
        static let getCategoryContent          = basePreFix    + "getCategoryContent"
        static let trending                    = basePreFix    + "trending"
        static let topTenSearch                = basePreFix    + "topTenSearch"
        static let searchKeyword               = basePreFix    + "searchKeyword"
    }
    
    struct Profile {
        private static let basePreFix         = baseUrl       + "user/profile/"
        static let watchList                  = basePreFix    + "watchList"
        static let removeWatchList            = basePreFix    + "removeWatchList"
        static let addToWatchList             = basePreFix    + "addToWatchList"
        static let getRecommended             = basePreFix    + "getRecommended"
        static let popular                    = basePreFix    + "popular"
        static let topten                     = basePreFix    + "topten"
        static let danceConcert               = basePreFix    + "danceConcert"
        static let currency                   = basePreFix    + "currency"
        
    }
    
    struct Content {
        private static let basePreFix          = baseUrl       + "content/"
        static let contentDetails              = basePreFix    + "contentDetails"
        static let mayLikeVideos               = basePreFix    + "mayLikeVideos"
        static let continueList                = basePreFix    + "continueList"
        static let popular                     = basePreFix    + "popular"
        static let topten                      = basePreFix    + "topten"
        static let trending                    = basePreFix    + "trending"
        static let search                      = basePreFix    + "search"
        static let searchV1                    = basePreFix    + "searchV1"
        static let danceDetails                = basePreFix    + "danceDetails"
        static let searchManage                = basePreFix    + "searchManage"
        static let addOrRemoveClap             = basePreFix    + "addOrRemoveClap"
        static let addOrRemoveOvation          = basePreFix    + "addOrRemoveOvation"
        static let saveContinueWatchTime       = basePreFix    + "continue"
        static let getCategoryContentV1        = basePreFix    + "getCategoryContentV1"
    }
}


