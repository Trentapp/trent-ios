//
//  AuthenticationManager.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 26.05.21.
//

import Firebase

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        AuthenticationManager.shared.currentUser = user
        print("Current User: \(user?.displayName) (\(user?.email)) with ID\(user?.uid)")
    }
    
    @Published var loggedIn = false {
        didSet {
            UserObjectManager.shared.loggedIn = loggedIn
        }
    }
    
    @Published var currentUser: User? = nil {
        didSet{
            AuthenticationManager.shared.loggedIn = (currentUser != nil)
        }
    }
}
