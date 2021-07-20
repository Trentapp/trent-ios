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
    
    func createNewUser(name: String, mail: String, password: String, completionHandler: @escaping (Bool, String?) -> Void) {
        FirebaseAuthClient.shared.createNewUser(name: name, mail: mail, password: password) { uid, error in
            if error == nil && uid != nil {
                // Backendclient: createNewUser BackendClient.shared.createNewUser(name: name, mail: mail, uid: uid)
            }
        }
    }
    
    func refresh() {
        let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
        
        // Backendclient: getUserObject let user = BackendClient.shared.getUserObject(for: uid)
        let user :UserObject? = UserObject(_id: "")
        if user != nil { UserObjectManager.shared.user = user! }
        self.refreshInventory()
        
    }
    
    private func refreshInventory() {
        var newInventory = [Product]()
        
        // Backendclient: getInventory newInventory = BackendClient.shared.getInventory(inventory: self.user?.inventory ?? [])
        UserObjectManager.shared.inventory = newInventory
    }
}
