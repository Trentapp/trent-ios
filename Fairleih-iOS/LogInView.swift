//
//  LoginView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 26.05.21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var mail = ""
    @State var password = ""
    
    let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        print("Current User: \(user?.displayName) (\(user?.email)) with ID\(user?.uid)")
      }
    
    var body: some View {
        VStack(alignment: .center, spacing: 1, content: {
            TextField("mail address", text: $mail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            TextField("password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            Button("Log in") {
                Auth.auth().signIn(withEmail: mail.lowercased(), password: password) { authResult, error in
                    let username = authResult?.additionalUserInfo?.username ?? "unknown"
                    let providerID = authResult?.additionalUserInfo?.providerID ?? "unknown"
                    print("User with name \(username) has successfully logged in. Provider ID: \(providerID)")
                    print(error.debugDescription)
                }
            }
        })
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

