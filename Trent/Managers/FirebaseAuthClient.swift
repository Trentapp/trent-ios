//
//  AuthenticationManager.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 26.05.21.
//

import Firebase

class FirebaseAuthClient: ObservableObject {
    static let shared = FirebaseAuthClient()
    
    let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        FirebaseAuthClient.shared.currentUser = user
        print("Current User: \(user?.displayName) (\(user?.email)) with ID\(user?.uid)")
    }
    
    @Published var currentUser: User? = nil {
        didSet{
            UserObjectManager.shared.loggedIn = (currentUser != nil)
            UserObjectManager.shared.refresh()
        }
    }
    
    func createNewUser(name: String, mail: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            let uid = authResult?.user.uid
            completionHandler(uid, error)
        }
    }
    
    func logOut(completionHandler: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(true)
        } catch {
            completionHandler(false)
        }
    }
    
    func deleteAccount(completionHandler: @escaping (Bool) -> Void) {
        let uid = currentUser?.uid
        if uid == nil { return }
        FirebaseAuthClient.shared.currentUser?.delete(completion: { error in
            if error == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
                print("An error occurred deleting the account: \(error?.localizedDescription)")
            }
        })
    }
    
    func changePassword(newPassword: String, completingHandler: @escaping (Bool) -> Void) {
        self.currentUser?.updatePassword(to: newPassword) { error in
            completingHandler(error == nil)
        }
    }
    
    func forgotPassword(mail: String, completingHandler: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: mail) { error in
          completingHandler(error == nil)
        }
    }
}
