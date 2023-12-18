//
//  PhoneNumberVerificationConstants.swift
//  KarGoRider
//
//  Created by Dev on 29/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var verificationCode: UIStoryboard {
        return UIStoryboard(name: "VerificationCode", bundle: nil)
    }
}
enum PNVSceenFlow: Int {
    case login = 1, signup = 2, editUserDetails = 3, splash  = 4
}
enum PNVOtpType: Int {
    case sms = 1, call
}
extension ViewControllerIdentifier {
    static let VerificationCodeVC = "VerificationCodeVC"
    static let resetPassword = "ResetPasswordViewController"
    static let verifyShow = "VerifyShowViewController"
}

extension ValidationError {
    static let emptyProfilePicture = "Profile picture cannot be empty"
    static let emptyFirstName = "First Name cannot be empty"
    static let partialName = "Name must have minimum 2 characters."
    static let emptyLastName = "Last Name cannot be empty"
    static let partialLastName = "Name must have minimum 2 characters."
    static let emptyPhoneNumber = "Phone Number cannot be Empty"

}

extension CharacterLimit {
    static let name = 50
    static let phoneNumber = 18
}

extension WebConstants {
    static let otp = "otp"
    static let otpBy = "otpBy"
    static let otpRequestType = "otpRequestType"
    static let waitingInterval = "remainingTime"
    static let type = "type"
    static let emailsent = "EMAIL_SENT"
    static let didNotReceive = "Didn’t receive your code yet?"
    static let weHave = "We have sent a reset password email to "
    static let pleaseClick = ". Please click the reset password link to set your new password."
}
