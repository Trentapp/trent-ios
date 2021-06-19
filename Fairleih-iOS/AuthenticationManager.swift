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
    
    @Published var currentUser: User? = nil {
        didSet{
            AuthenticationManager.shared.loggedIn = (currentUser != nil)
            UserObjectManager.shared.refresh()
        }
    }
    
    func createNewUser(name: String, mail: String, password: String) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if error == nil {
                let uid = authResult?.user.uid ?? ""
                BackendClient.shared.createNewUser(name: name, mail: mail, uid: uid)
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            AuthenticationManager.shared.loggedIn = false
            UserObjectManager.shared.user = nil
        } catch {
            
        }
    }
    
    func deleteAccount() {
        let uid = currentUser?.uid
        if uid == nil { return }
        AuthenticationManager.shared.currentUser?.delete(completion: { error in
            if error == nil {
                BackendClient.shared.deleteUserFromDB(with: uid!)
            } else {
                print("An error occurred deleting the account: \(error?.localizedDescription)")
            }
        })
    }
}
