//
//  PushNotificationHandler.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

extension Notification.Name {
    static let notificationTapped = Notification.Name("notificationTapped")
}

extension UNNotification {
    var userInfo: [AnyHashable : Any] {
        return self.request.content.userInfo
    }
}


extension UNNotificationResponse {
    var userInfo: [AnyHashable : Any] {
        return self.notification.request.content.userInfo
    }
}


enum PushNotificationType: Int {
    case broadcast = 0
    case PRESENTER_PUSH = 1
    case BROADCAST_PUSH = 4
}

extension String {
    var intValue: Int? {
        let intValue = Int(self)
        return intValue
    }
}

protocol RequestListner {
}

protocol RequestMyAccountUpdatedListner: RequestListner {
    func requestMyAccountUpdated(Update: Bool)
}

protocol PiPListner {
}
protocol UpdatePiPListner: PiPListner {
    func pipListnerCallBack()
}


class PushNotificationHandler: NSObject {
    
    static let shared: PushNotificationHandler = PushNotificationHandler()
    
    var notificationUserInfo: [AnyHashable : Any]?

    private override init() {
    }
    
    func configure() {
        UNUserNotificationCenter.current().delegate = self
        handleBadgeCount()
        Messaging.messaging().delegate = self
    }
    
    func handleBadgeCount() {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func askForPushNotifications(_ completionHandler: (() -> Void)?) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completionHandler?()
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func showBroadcastPushAlert(userInfo: [AnyHashable: Any]) {
        let title = userInfo["title"] as? String
        let message = userInfo["message"] as? String
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in //Just dismiss the action sheet
        }
        
        alertController.addAction(okAction)
        
        var parentController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while (parentController?.presentedViewController != nil &&
                parentController != parentController!.presentedViewController) {
            parentController = parentController!.presentedViewController
        }
        parentController?.present(alertController, animated:true, completion:nil)
        
        
        //KAPPDELEGATE.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    func handlePushNotification(_ response: UNNotificationResponse) {
        let userInfo = response.userInfo
        if let notificationType = (userInfo["pushType"] as? String ?? "").intValue {
            switch notificationType {
            
            case PushNotificationType.broadcast.rawValue:
                print("Broadcast push received")
                
            case PushNotificationType.PRESENTER_PUSH.rawValue:
                if (UIApplication.topViewController() is MyAccountViewController){
                    if let listner =  UIApplication.topViewController() as? RequestMyAccountUpdatedListner {
                        listner.requestMyAccountUpdated(Update: true)
                    }
                }else{
                    delay(0.5){
                        KAPPDELEGATE.needsRirectToMyAccount = true
                        KAPPDELEGATE.updateRootController(HomeViewController.getController(), transitionDirection: .toRight, embedInNavigationController: false)
                    }
                }
                
            case PushNotificationType.BROADCAST_PUSH.rawValue: break
                
                
            default:
                print("Notification type not configured")
            }
        }
    }
    
    func shouldPresentNotificationBanner(_ response: UNNotification) -> Bool {
        let userInfo = response.userInfo
        if let notificationType = (userInfo["pushType"] as? String ?? "").intValue {
            switch notificationType {
            
            case PushNotificationType.broadcast.rawValue:
                return true
                
            case PushNotificationType.PRESENTER_PUSH.rawValue:
                self.showBroadcastPushAlert(userInfo: userInfo)
                
            case PushNotificationType.BROADCAST_PUSH.rawValue:
                self.showBroadcastPushAlert(userInfo: userInfo)
                
            default:
                return false
            }
        }
        return true
    }
}

extension PushNotificationHandler: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        handleBadgeCount()
        if self.shouldPresentNotificationBanner(notification) {
            completionHandler([.alert, .sound, .badge])
        } else {
            completionHandler([])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleBadgeCount()
        self.notificationUserInfo = response.userInfo
        NotificationCenter.default.post(name: .notificationTapped, object: nil)
        self.handlePushNotification(response)
        completionHandler()
    }
    
}

extension PushNotificationHandler: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken: " + fcmToken!)
        AppStorage.shared.fcmToken = fcmToken!
    }
}



