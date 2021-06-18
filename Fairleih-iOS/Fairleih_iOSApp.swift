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
        AuthenticationManager.shared
        return true
    }
}

@main
struct Fairleih_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var userObjectManager = UserObjectManager.shared
    
    var body: some Scene {
        WindowGroup {
            if userObjectManager.loggedIn {
                MainView()
            } else {
                SignupView()
            }
        }
        
    }
}
