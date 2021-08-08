//
//  Fairleih_iOSApp.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import SwiftUI
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FirebaseAuthClient.shared
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken
                        deviceToken: Data) {
        //       self.sendDeviceTokenToServer(data: deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("success in registering for remote notifications with token \(deviceTokenString)")
        BackendClient.shared.addAPNToken(token: deviceTokenString) { success in
            if !success {
                // well...
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Received push notification: \(userInfo)")
        let aps = userInfo["aps"] as! [String: Any]
        print("\(aps)")
    }
}

@main
struct TrentApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var userObjectManager = UserObjectManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        
    }
}
