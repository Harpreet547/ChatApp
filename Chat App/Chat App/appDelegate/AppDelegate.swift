//
//  AppDelegate.swift
//  Chat App
//
//  Created by Zensar on 17/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        IQKeyboardManager.sharedManager().enable = true
        
        setUpFCM(application)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let _ = User.currentUser {
            self.setUserOnlineStatus(status: false)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let _ = User.currentUser {
            self.setUserOnlineStatus(status: true)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
    }
}

extension AppDelegate {
    //MARK: USER DEFINED METHODS
    func showChatsScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatNavVCIdentifier = AppConstants.StoryboardIdentifiers.ChatNavController.rawValue
        let chatNavVC = storyboard.instantiateViewController(withIdentifier: chatNavVCIdentifier) as! UINavigationController
        self.window?.rootViewController = chatNavVC
        self.window?.makeKeyAndVisible()
    }
    
    func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVCIdentifier = AppConstants.StoryboardIdentifiers.LoginViewController.rawValue
        let loginVC = storyboard.instantiateViewController(withIdentifier: loginVCIdentifier) as! LoginViewController
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
    }
    
    func setUserOnlineStatus(status: Bool) {
        let ref = FIRDatabase.database().reference(withPath: "users")
        let currentUserRef = ref.child(Utils.getUserKeyUsing(email: User.currentUser!.email))
        
        currentUserRef.updateChildValues([
            "online": status
            ])
    }
    
    func setUpFCM(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: FIRMessagingDelegate {
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}

