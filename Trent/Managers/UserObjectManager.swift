//
//  File.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 31.05.21.
//

import Foundation

class UserObjectManager: ObservableObject {
    static var shared = UserObjectManager()
    
    @Published var showAuthentication = false
    
    @Published var loggedIn = false {
        didSet {
            UserDefaults.standard.set(loggedIn, forKey: "loggedIn") //Bool
        }
    }
    @Published var user: UserObject? = nil {
        didSet {
            if user == nil {
                self.loggedIn = false
            }
        }
    }
    
    @Published var inventory: [Product] = []
    init() {
        self.loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    }
    
    func refresh() {
        let uid = AuthenticationManager.shared.currentUser?.uid ?? ""
        
        DispatchQueue.main.async {
            let user = BackendClient.shared.getUserObject(for: uid)
            if user != nil { UserObjectManager.shared.user = user! }
            self.refreshInventory()
        }
        
        
    }
    
    private func refreshInventory() {
        var newInventory = [Product]()
        
        DispatchQueue.global().async {
            newInventory = BackendClient.shared.getInventory(inventory: self.user?.inventory ?? [])
            DispatchQueue.main.async {
                UserObjectManager.shared.inventory = newInventory
            }
        }
    }
}
