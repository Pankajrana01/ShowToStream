//
//  VerificationCodeViewModel.swift
//  KarGoRider
//
//  Created by Dev on 30/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class VerificationCodeViewModel: BaseViewModel {
    let user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    var secondaryEmailForUpdate: String?
    var screenFlow: PNVSceenFlow!
    var otpType: PNVOtpType = .sms
    var waitingTime: Int = 30
    
    private var timerTime: Int = 30
    private lazy var timeLeft = timerTime
    private var timerStartDate: Date?
    
    var timerLabel: UILabel!
    var countryCode: String = ""
    var phoneNumber: String = ""
    var resendView : UIView!
    
    weak var callButton: UIButton!
    weak var resendButton: UIButton!
    weak var continueButton : UIButton!
    weak var email : UILabel!
    
    var completionHandler: ((Bool) -> Void)?
    
    private func apiSuccess() {
        completionHandler?(true)
    }
    override func viewLoaded() {
        super.viewLoaded()
        timerLabel.text = ""
    }
    
    func gotoLoginScreen(){
        KAPPDELEGATE.updateRootController(LoginViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
    
    
    //MARK : to fill otp ...
    func otpFilledByEmail(otpText: String) {
        if let params = self.validateModelWith(otpTextField: otpText) {
            self.processDataforVerifyOtp(params: params)
        }
    }
    
    //MARK :
    //MARK : to tap on resend button ...
    func resendButtonTapped() {
        otpType = .sms
        if self.timeLeft == 0 {
            self.resendView.isHidden = true
            var params = [String: Any]()
            params[WebConstants.email] = email.text
            self.processDataforResendOtp(params: params)
        }
    }
}

//MARK :
//MARK : add validation ...
extension VerificationCodeViewModel { // validations
    func validateModelWith(otpTextField: String) -> [String: Any]? {
        let otp = otpTextField
        if otp.count == 0{
            showMessage(with: ValidationError.emptyOtp)
            return nil
        }
        else if otp.count < 4 {
            showMessage(with: ValidationError.invalidOtp)
            return nil
        }
        var params = [String: Any]()
        params[WebConstants.token] = otp
        return params
        
    }
}
//MARK :
//MARK : to process data ...

extension VerificationCodeViewModel {
    func viewAppeared() {
        NotificationCenter.default.removeObserver(self, name: .appEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appEnterForeground),
                                               name: .appEnterForeground,
                                               object: nil)
        timerTime = 30
        self.startTimer()
    }
    @objc
    func appEnterForeground() {
        
        if let timerStartDate = timerStartDate {
            timeLeft = timerTime - Int(Date().timeIntervalSince(timerStartDate))
        }
    }
    func viewDisAppeared() {
        NotificationCenter.default.removeObserver(self, name: .appEnterForeground, object: nil)
        stopTimer()
    }

    func stopTimer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.timeLeft = 0
        timerStartDate = nil
        NotificationCenter.default.removeObserver(self)
    }

    func startTimer() {
        if timerStartDate == nil {
            timeLeft = timerTime
            if timeLeft > 0 {
                if timeLeft > 9 {
                    timerLabel.text = getTimeLeftString()
                } else {
                    timerLabel.text = getTimeLeftString()
                }
                callButton?.isHidden = true
                resendButton?.isHidden = true
            } else {
                timerLabel.text = WebConstants.didNotReceive
                callButton?.isHidden = false
                resendButton?.isHidden = false
            }
            timerStartDate = Date()
        }
        self.perform(#selector(self.updateTimer), with: nil, afterDelay: 1, inModes: [RunLoop.Mode.default])
    }

    @objc
    func updateTimeLeft() {
        if let timerStartDate = timerStartDate {
            timeLeft = timerTime - Int(Date().timeIntervalSince(timerStartDate))
        }
    }
    
    @objc
    func updateTimer() {
        if timeLeft > 0 {
            callButton?.isHidden = true
            resendButton?.isHidden = true
            self.timeLeft -= 1
            if timeLeft > 9 {
                timerLabel.text = getTimeLeftString()
            } else {
                timerLabel.text = getTimeLeftString()
            }
            self.perform(#selector(self.updateTimer), with: nil, afterDelay: 1, inModes: [RunLoop.Mode.default])
        } else {
            self.timeLeft = 0
            timerStartDate = nil
            timerLabel.text = WebConstants.didNotReceive
            callButton?.isHidden = false
            resendButton?.isHidden = false
            resendView.isHidden = false
        }
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    func getTimeLeftString() -> String {
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: timeLeft)
        let hString = h > 9 ? "\(h)" : "0\(h)"
        let mString = m > 9 ? "\(m)" : "0\(m)"
        let sString = s > 9 ? "\(s)" : "0\(s)"

        if h > 0 {
            return "\(hString):\(mString):\(sString)"
        } else {
            return "\(mString):\(sString)"
        }
    }
}

extension VerificationCodeViewModel {
    //MARK:- API Call...
    private func processDataforVerifyOtp(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.OTPApis.verifyEmail,
                               params: params,
                               headers: nil,
                               method: .get) { response, _  in
                                if !self.hasErrorIn(response) {
                                    //let responseData = response![APIConstants.data] as! [String: Any]
                                    //self.user.updateWith(responseData)
                                    showSuccessMessage(with: SucessMessage.emailVerificationSuccess)
                                    
                                    //to check screen flow and send to next screen...
                                    if self.screenFlow == .login {
                                        self.proceedToWhoWatching()
                                    } else if self.screenFlow == .signup {
                                        KUSERMODEL.setUserLoggedIn(true)
                                        self.proceedNextLandingScreen()
                                    } else if self.screenFlow == .splash{
                                        self.proceedNextLandingScreen()
                                    } else{
                                        self.apiSuccess()
                                    }
                                }
                                hideLoader()
        }
    }
    
    func proceedNextLandingScreen() {
        let controller = LandingViewController.getController()
        controller.clearNavigationStackOnAppear = true
        controller.show(from: self.hostViewController)
    }
    private func proceedToWhoWatching() {
        WhoWatchingViewController.show(from: hostViewController, forcePresent: true, autoEmbedInNavigationControllerIfPresent: true)
    }
    private func processDataforResendOtp(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.OTPApis.resendVerifyEmail,
                               params: params,
                               headers: nil,
                               method: .put) { response, _  in
                                if !self.hasErrorIn(response) {
                                    
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.user.updateWith(responseData)
                                    self.timerTime = 30
                                    self.waitingTime = 30
                                    self.startTimer()
                                }else{
                                    if response?[APIConstants.responseType] as? String == WebConstants.emailAlreadyVerified{
                                        self.resendView.isHidden = false
                                    }
                                }
                                hideLoader()
        }
    }
}
