//
//  AuthenticationManager.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 26.05.21.
//

import SwiftUI
import Combine
import Firebase

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        AuthenticationManager.shared.currentUser = user
        print("Current User: \(user?.displayName) (\(user?.email)) with ID\(user?.uid)")
    }
    
    @Published var loggedIn = false
    @Published var currentUser: User? = nil {
        didSet{
            print("loggedIn will be set to \(AuthenticationManager.shared.loggedIn) because user is \(currentUser). \(currentUser != nil)")
            if currentUser != nil {
                AuthenticationManager.shared.loggedIn = true
                print("Set the value to true. Value: \(AuthenticationManager.shared.loggedIn)")
            } else {
                AuthenticationManager.shared.loggedIn = false
                print("Set the value to false. Value: \(AuthenticationManager.shared.loggedIn)")
            }
        }
    }
}
