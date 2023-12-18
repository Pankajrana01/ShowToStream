//
//  ResetPasswordViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 05/01/21.
//

import Foundation
import UIKit

class ResetPasswordViewModel: BaseViewModel {
    
    var completionHandler: ((Bool) -> Void)?
    var email = ""
    var isCome = ""
    var waitingTime: Int = 0
    
    private var timerTime: Int = 0
    private lazy var timeLeft = timerTime
    private var timerStartDate: Date?
    
    var timerLabel: UILabel!
    var resendView : UIView!
    
    func gotoLoginScreen(){
        KAPPDELEGATE.updateRootController(LoginViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
    
    //MARK :
    //MARK : to tap on resend button ...
    func resendButtonTapped() {
        var params = [String: Any]()
        params[WebConstants.emailOrPhoneNumber] = self.email
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        params[WebConstants.deviceName] = DEVICENAME
        params[WebConstants.platform] = Platform.iOS.rawValue
        self.processDataforResendOtp(params: params)
    }
}

extension ResetPasswordViewModel {
    func viewAppeared() {
        NotificationCenter.default.removeObserver(self, name: .appEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appEnterForeground),
                                               name: .appEnterForeground,
                                               object: nil)
        timerTime = waitingTime
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
                resendView.isHidden = true
            } else {
                timerLabel.text = WebConstants.didNotReceive
                resendView.isHidden = false
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
            self.timeLeft -= 1
            if timeLeft > 9 {
                timerLabel.text = getTimeLeftString()
            } else {
                timerLabel.text = getTimeLeftString()
            }
            resendView.isHidden = true
            self.perform(#selector(self.updateTimer), with: nil, afterDelay: 1, inModes: [RunLoop.Mode.default])
        } else {
            self.timeLeft = 0
            timerStartDate = nil
            timerLabel.text = WebConstants.didNotReceive
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

extension ResetPasswordViewModel {
    //MARK:- API Call...
    func processDataforResendOtp(params: [String: Any]) {
        showLoader()
            ApiManager.makeApiCall(APIUrl.UserApis.forgotPassword,
                                   params: params,
                                   method: .put) { response, _ in
                if !self.hasErrorIn(response) {
                    
                    if let nextWaitingTime = (response![APIConstants.data] as! [String: Any])[WebConstants.waitingInterval] as? Int{
                        self.timerTime = nextWaitingTime
                        self.startTimer()
                    }else{
                        if (response![APIConstants.data] as! [String: Any])[WebConstants.type] as? String == WebConstants.emailsent {
                        showSuccessMessage(with: SucessMessage.forgotSuccess)
                        }
                    }
                }
                hideLoader()
            }
        }
}

