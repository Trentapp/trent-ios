//
//  File.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 31.05.21.
//

import Foundation

class UserObjectManager: ObservableObject {
    static var shared = UserObjectManager()
    
    @Published var loggedIn = false {
        didSet {
            UserDefaults.standard.set(loggedIn, forKey: "loggedIn") //Bool
        }
    }
    @Published var user: UserObject?
    
    init() {
        self.loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    }
}
