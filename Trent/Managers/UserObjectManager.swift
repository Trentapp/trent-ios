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
                BackendClient.shared.createNewUser(name: name, mail: mail, uid: uid ?? "") { userObject in
                    UserObjectManager.shared.user = userObject
                }
            }
        }
    }
    
    func deleteUser(completionHandler: @escaping (Bool) -> Void){
        FirebaseAuthClient.shared.deleteAccount { success in
            if(success) {
                BackendClient.shared.deleteUserFromDB { success in }
            }
        }
    }
    
    func logOut(completionHandler: @escaping (Bool) -> Void) {
        FirebaseAuthClient.shared.logOut { success in
            if success {
                UserObjectManager.shared.user = nil
            }
            completionHandler(success)
        }
    }
    
    func refresh() {
        BackendClient.shared.getUserObject { user in
            if user != nil { UserObjectManager.shared.user = user! }
            self.refreshInventory()
        }
    }
    
    private func refreshInventory() {
        var newInventory = [Product]()
        
        // Backendclient: getInventory newInventory = BackendClient.shared.getInventory(inventory: self.user?.inventory ?? [])
        UserObjectManager.shared.inventory = newInventory
    }
}
