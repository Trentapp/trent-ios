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
    @Published var user: UserObject? = nil {
        didSet {
            if user == nil {
                UserObjectManager.shared.loggedIn = false
            }
        }
    }
    
    @Published var inventory: [Product] = []
    init() {
        self.loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    }
    
    func refresh() {
        let uid = AuthenticationManager.shared.currentUser?.uid ?? ""
        let user = BackendClient.shared.getUserObject(for: uid)
        DispatchQueue.main.async {
            if user != nil { UserObjectManager.shared.user = user! }
            self.refreshInventory()
        }
        
        
    }
    
    private func refreshInventory() {
        var newInventory = [Product]()
        
        DispatchQueue.global().async {
            for productId in self.user?.inventory ?? [] {
                let product = BackendClient.shared.getProduct(for: productId)
                if product != nil { newInventory.append(product!) }
            }
            DispatchQueue.main.async {
                UserObjectManager.shared.inventory = newInventory
            }
        }
    }
}
