//
//  AppDelegate.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SVProgressHUD
import SwiftMessages
import Firebase
import FirebaseCore
import FirebaseCrashlytics
import FirebaseMessaging
import GoogleSignIn
import FBSDKLoginKit
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var user = UserModel.shared.user
    var sessionCreated: Bool = false
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    var shouldRefreshCommonUrls: Bool = true
    var commonUrls = [CommonUrl]()
    var needsRirectToMyAccount: Bool = false
    var universal_ShowId = ""
    let kDebugLoggingEnabled = true
    let kReceiverAppID = "341387A3"
        //"2F9804BE"
        //"341387A3"
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //MARK: this is check to move jail break ...
        if self.checkIfShouldBlock() {
            self.moveToJailBreaked()
        }else{
            self.initializeSVProgressHud()
            self.initializeSwiftMessages()
            self.startListeningNetworkReachability()
            self.initializeBaseViewControllerSwizzling()
            self.initializeSharedDataManager()
            self.initializeVideoPlayerManager()
            self.initializeKeyboardManager()
            self.initializeFirebase()
            self.initializePushNotifications()
            self.initializeInitialViewController()
            self.initializeGoogleSignIn()
        }
        return true
    }
 
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: .appEnterForeground, object: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: .appBecomeInactive, object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        PushNotificationHandler.shared.handleBadgeCount()
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appHandled = application(app, open: url,
                                     sourceApplication: nil,
                                     annotation: [:])
        
        let fbHandled = ApplicationDelegate.shared.application(app,
                                                               open: url,
                                                               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                               annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let googleHandled = GIDSignIn.sharedInstance().handle(url)
                
        return fbHandled || googleHandled || appHandled
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print(userActivity.webpageURL?.absoluteString as Any) // original link as parameter for parsing function
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
    
        
        print(components.path)
       
        if let link = userActivity.webpageURL?.absoluteString {
            let aLink = link.components(separatedBy: "id=")
            let id:String = aLink.last ?? ""
            print(id)
            self.universal_ShowId = id
            var parms = [String:Any]()
            parms[WebConstants.id] = self.universal_ShowId
        
            if KUSERMODEL.isLoggedIn() {
                parms[WebConstants.profileId] = KUSERMODEL.selectedProfile._id!
                self.processDataForLoginDetailContent(params: parms)
            } else {
                self.processDataForDetailContent(params: parms)
            }
        }
        
        return false
    }
    
   
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ShowToStream")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    private func initializeBaseViewControllerSwizzling() {
        BaseViewController.classInit
    }

    private func initializeSharedDataManager() {
        SharedDataManager.shared.initialize()
    }

    private func initializeVideoPlayerManager() {
        VideoPlayerManager.shared.initialize()
    }

    private func initializeKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
    
    }

    private func initializeSVProgressHud() {
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    private func initializeSwiftMessages() {
        SwiftMessages.defaultConfig.presentationStyle = .top
        SwiftMessages.defaultConfig.duration = SwiftMessages.Duration.seconds(seconds: 3.0)
        SwiftMessages.defaultConfig.preferredStatusBarStyle = .lightContent
    }
    
    private func initializePushNotifications() {
        PushNotificationHandler.shared.configure()
        PushNotificationHandler.shared.askForPushNotifications { }

    }
    private func initializeFirebase() {
//      FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "DynamicLink"
        FirebaseApp.configure()
    }
    
    func initializeInitialViewController() {
        guard let window = self.window else {
            return
        }
        let navVC = UINavigationController(rootViewController: SplashViewController.getController())
        navVC.navigationBar.isHidden = true
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
    
}

extension AppDelegate {
    private func initializeGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = GoogleSignInApiKey
    }
}



extension AppDelegate{
    
    func loadData(completion: @escaping (_ urls: [CommonUrl]?) -> Void) {
        if shouldRefreshCommonUrls {
            self.loadCommonUrls { urls in
                completion(urls)
            }
        }
    }
    
    //MARK: Load all common URl's ...
    func loadCommonUrls(completion: @escaping (_ urls: [CommonUrl]?) -> Void) {
        shouldRefreshCommonUrls = false
        ApiManager.makeApiCall(APIUrl.UserApis.commonUrl, method: .get) { response, _ in
            if !BaseViewModel.hasErrorIn(response) {
                if let responseData = response![APIConstants.data] as? [[String:Any]]{
                    for i in 0..<responseData.count{
                        self.commonUrls.append(CommonUrl(name: (responseData[i] as AnyObject).value(forKey: WebConstants.name) as? String ?? "", url: (responseData[i] as AnyObject).value(forKey: WebConstants.url) as? String ?? ""))
                    }
                    completion(self.commonUrls)
                }
               
            }else {
                // in case response is not correct, set it to true so that it should try to refresh the data on next attempt.
                self.shouldRefreshCommonUrls = true
            }
        }
    }
    
    
    func processDataForDetailContent(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.HomeCommon.contentDetails,
                               params: params,
                               method: .get) { response, _ in
                                if !BaseViewModel.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String:Any]
                                    
                                    let show = Show()
                                    show.updateWithDetailData(responseData)
                                    KAPPDELEGATE.updateRootController(ShowDetailViewController.getController(with: "UniversalLink", show: show, universal_showId: self.universal_ShowId), transitionDirection: .toTop, embedInNavigationController: false)
                                    
                                }
                                hideLoader()
        }
    }
    
    // ---------------------------
    //MARK: Api for Login User ...
    func processDataForLoginDetailContent(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.contentDetails,
                               params: params,
                               headers: headers,
                               method: .get) { response, _ in
                                if !BaseViewModel.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String:Any]
                                    let show = Show()
                                    show.updateWithDetailData(responseData)
                                    KAPPDELEGATE.updateRootController(ShowDetailViewController.getController(with: "UniversalLink", show: show, universal_showId: self.universal_ShowId), transitionDirection: .toTop, embedInNavigationController: false)
                                }
                                hideLoader()
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

//MARK: JAIL BREAK
extension AppDelegate {
    func checkIfShouldBlock() -> Bool { //
        guard let cydiaUrlScheme = URL(string: "cydia://package/com.example.package") else { return false }
        
        if UIApplication.shared.canOpenURL(cydiaUrlScheme) {
            return true
        }
        #if arch(i386) || arch(x86_64)
        // This is a Simulator not an idevice
        return false
        #endif
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/usr/bin/ssh") ||
            fileManager.fileExists(atPath: "/private/var/lib/apt") {
            return true
        }
        if canOpen(path: "/Applications/Cydia.app") ||
            canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen(path: "/bin/bash") ||
            canOpen(path: "/usr/sbin/sshd") ||
            canOpen(path: "/etc/apt") ||
            canOpen(path: "/usr/bin/ssh") {
            return true
        }
        let path = "/private/" + NSUUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
    
    func moveToJailBreaked() {  // set your "Jail Broken device info" screen as window's root
        var rootVC = UIViewController()
        rootVC = JailBreakedViewController.getController()
        
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.isHidden = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navVC
        appDelegate.window?.makeKeyAndVisible()
        return
    }
}


