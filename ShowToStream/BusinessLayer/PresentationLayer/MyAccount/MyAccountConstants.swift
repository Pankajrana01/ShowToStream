//
//  MyAccountConstants.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 16/12/20.
//

import UIKit

extension UIStoryboard {
    
    class var myAccount: UIStoryboard {
        return UIStoryboard(name: "MyAccount", bundle: nil)
    }
}
extension ViewControllerIdentifier {
    static let myAccount                   = "MyAccountViewController"
    static let userDetailAccount           = "UserAccountDetailViewController"
    static let editUserDetailAccount       = "EditUserDetailViewController"
    static let logout                      = "LogoutViewController"
    static let changePassword              = "ChangePasswordViewController"
    static let forgotPassword              = "ForgotPasswordViewController"
    static let about                       = "AboutViewController"
    static let contactUs                   = "ContactUsViewController"
    static let becomePresenter             = "BecomePresenterViewController"
    static let manageProfile               = "ManageProfileViewController"
    static let playTV                      = "PlayTvViewController"
    static let streamQuality               = "StreamQualityViewController"
    static let deleteProfile               = "DeleteProfileViewController"
    static let earnings                    = "EarningsViewController"
    static let checkAccount                = "CheckAccountViewController"
}

extension TableViewCellIdentifier {
    static let myAccountTableCell            = "MyAccountTableCell"
    static let presenterTableCell            = "PresenterTableCell"
    static let earningTableCell              = "EarningTableCell"
    static let accountDetailTableCell        = "accountDetailTableCell"
}

extension TableViewNibIdentifier {
    static let myAccountTableCell            = "MyAccountTableCell"
    static let presenterTableCell            = "PresenterTableCell"
    static let earningTableCell              = "EarningTableCell"
    static let accountDetailTableCell        = "AccountDetailTableCell"
}

extension StringConstants {
    static let myAccount                    = "My Account"
    static let playonTV                     = "Play on TV"
    static let savedCards                   = "Saved Cards"
    static let streamingQuality             = "Streaming Quality"
    static let preferences                  = "Preferences"
    static let aboutShowToStream            = "About ShowToStream"
    static let legal                        = "Legal"
    static let faqs                         = "FAQs"
    static let contactUs                    = "Contact Us"
    static let doYouHave                    = "Do you have a show that needs an audience? Click here!"
    static let good                         = "Good"
    static let drama                        = "Drama"
    static let thriller                     = "Thriller"
    static let more                         = "4 more"
    static let faq                          = "FAQs"
    static let about                        = "About"
    static let writehere                    = "Write your message here"
    static let briefAbout                   = "Briefly, tell us about your show. Eg: Show name, What it’s about, Genre etc."
    static let editProfile                  = "Edit Profile"
    static let newProfile                   = "Create\nNew Profile"
    static let cancel                       = "Cancel"
    static let manageProfile                = "Manage Profile"
    static let phoneNumberPlaceholder       = "Phone Number"
    static let createProfile                = "Create Profile"
    static let updateProfile                = "Update Profile"
    static let changePassword               = "changePassword"
}

extension ValidationError {
    static let empty = "This field is Required."
    static let emptyEmail = "Please enter your Email Address"
    static let invalidEmail = "Please enter correct format of Email id. For Eg: User@user.com, user@user.co etc"

    static let invalidPassword = "Password length should be in between 6 to 20 digits."
    static let invalidPasswordSpecial = "Password should contain a number and a special character"
    static let confirmPasswordMismatch = "Confirm Password is not same as New Password."
    static let emptyCurrentPassword = "Old Password can not be empty."
    static let emptyNewPassword = "New Password can not be empty."
    static let emptyConfirmPassword = "Confirm Password can not be empty."
    static let sameNewPassword = "New Password should not be same as Old Password"
    static let passwordsMismatch = "New password and confirm password doesn't match"
    
    static let emptyProfileName = "Profile name can not be empty."
    static let invalidProfileName = "Profile name should not be less than 3 Characters and not more than 50 Characters."
    static let validProfileName = "Profile name should only allow Alphanumeric."
    static let emptyFullName = "Full name can not be empty."
    static let invalidFullName = "Full name should not be less than 3 Characters and not more than 50 Characters."
    static let validFullName = "Full name should only allow Alphabets."
    static let invalidCompanyName = "Company name must be at least 3 Characters and not more than 55 Characters."
    static let emptyMessage = "Message can not be empty."
    static let emptyCompanyName = "Company name can not be empty."
    static let validCompanyName = "Company name should only allow Alphabets."
    static let emptyPassword = "Password can not be empty."
    static let invalidPhoneNumber = "Phone Number length should be in between 6 to 15 digits long."
    static let invalidPhoneNumberWithZero = "Phone Number length should be in between 7 to 16 digits long."
    static let invalidPhoneNumberWithZeroStart = "Phone Number cannot start with 0."
    
    static let invalidOtp = "This OTP is invalid"
    static let emptyOtp = "OTP can not be empty."
    static let invalidCode = "This Code is invalid"
    static let emptyCode = "Code can not be empty."
}

extension SucessMessage {
    static let forgotSuccess = "Reset password link has been sent to your registered email. Please reset your password."
    static let changePasswordSuccess = "Password successfully changed. Please log in again"
    static let editProfileSuccess = "Your profile edit successfully"
    static let createProfileSuccess = "Your profile created successfully"
    static let contactUsSuccess = "Thanks for contacting us! We will be in touch with you shortly."
    static let becomePresenterSuccess = "Thanks for contacting us! We will be in touch with you shortly."
    static let playTvSuccess = "Success! Your device is now Registered to your ShowToStream Account."
    static let emailVerificationSuccess = "OTP Successfully Verified."
    static let codeVerificationSuccess = "Pin code Successfully Verified."
}

