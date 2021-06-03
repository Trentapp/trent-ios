//
//  SignupView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 26.05.21.
//

import SwiftUI
import Firebase

struct SignupView: View {
    
    @State var name = ""
    @State var mail = ""
    @State var password = ""
    @State var password_confirmed = ""
    
    @State var isShownPasswordAlert = false
    
    @ObservedObject var authenticationManager: AuthenticationManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing, spacing: 20, content: {
                Spacer()
                    .frame(height:10)
                TextField("name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.words)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                TextField("mail address", text: $mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                SecureField("password", text: $password)
                    .textContentType(.newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                SecureField("confirm password", text: $password_confirmed)
                    .textContentType(.newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Button("Sign up") {
                    if(password == password_confirmed){
                        authenticationManager.createNewUser(name: name, mail: mail, password: password)
                    } else {
                        isShownPasswordAlert.toggle()
                    }
                }
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Spacer()
                
                HStack {
                    Spacer()
                    NavigationLink("Already have an Account?", destination: LoginView())
                    Spacer()
                }
                
                NavigationLink("", destination: MainView().navigationBarHidden(true), isActive: $authenticationManager.loggedIn).hidden()
            })
            
            .alert(isPresented: $isShownPasswordAlert, content: {
                Alert(title: Text("Passwords doesn't match"), message: Text("Please make sure that you have entered the same password."), dismissButton: .default(Text("Okay")))
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
