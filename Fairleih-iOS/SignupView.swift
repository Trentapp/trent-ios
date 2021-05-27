//
//  SignupView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 26.05.21.
//

import SwiftUI
import Firebase

struct SignupView: View {
    
    @State var mail = ""
    @State var password = ""
    @State var password_confirmed = ""
    
    @ObservedObject var authenticationManager: AuthenticationManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing, spacing: 20, content: {
                Spacer()
                    .frame(height:10)
                TextField("mail address", text: $mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                TextField("password", text: $password)
                    .textContentType(.newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                TextField("confirm password", text: $password_confirmed)
                    .textContentType(.newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Button("Sign up") {
                    if(password == password_confirmed){
                        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
                            print(authResult?.user)
                        }
                    } else {
                        Alert(title: Text("Passwords doesn't match"), message: Text("Please make sure that you have entered the same password."), dismissButton: .default(Text("Okay")))
                    }
                }
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Spacer()
                
                HStack {
                    Spacer()
                    NavigationLink("Already have an Account?", destination: LoginView())
                    Spacer()
                }
                
                NavigationLink("", destination: ContentView().navigationBarHidden(true), isActive: $authenticationManager.loggedIn).hidden()
            })
            
            
            
            .navigationTitle("Sign up")
            .navigationBarHidden(false)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
