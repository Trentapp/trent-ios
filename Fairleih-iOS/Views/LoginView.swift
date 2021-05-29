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
    
    @ObservedObject var authenticationManager = AuthenticationManager.shared
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 20, content: {
            Spacer()
                .frame(height:10)
            TextField("mail address", text: $mail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            TextField("password", text: $password)
                .textContentType(.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Button("Log in") {
                Auth.auth().signIn(withEmail: mail.lowercased(), password: password) { authResult, error in
                    let username = authResult?.additionalUserInfo?.username ?? "unknown"
                    let providerID = authResult?.additionalUserInfo?.providerID ?? "unknown"
                    print("User with name \(username) has successfully logged in. Provider ID: \(providerID)")
                    print(error.debugDescription)
                }
            }
            .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Spacer()
            NavigationLink("", destination: MainView(), isActive: $authenticationManager.loggedIn).hidden()
        })
        .navigationTitle("Log in")
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

