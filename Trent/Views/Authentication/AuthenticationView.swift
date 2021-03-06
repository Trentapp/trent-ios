//
//  Authentication.swift
//  Trent
//
//  Created by Fynn Kiwitt on 14.07.21.
//

import SwiftUI
import Firebase
import AuthenticationServices
import CryptoKit


struct AuthenticationView: View {
    
    var wantedTab: Int?
    @State var useMail = false {
        willSet {
            animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animate = false
            }
        }
    }
    @State var createNewAccount = true {
        willSet {
            animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animate = false
            }
        }
    }
    @State var animate = false
    @State var isLoading = false
    
    @State var isShownPasswordAlert = false
    @State var isShownFailureAlert = false
    @State var isShownEmptyAlert = false
    @State var isShownSingInFailureAlert = false
    
    @State var firstName = ""
    @State var lastName = ""
    @State var mail = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    @Environment(\.presentationMode) var presentationMode
    // Unhashed nonce.
    @State var currentNonce: String?
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func successfullyConcluded() {
        if wantedTab != nil {
            MainViewProperties.shared.selectedItem = tabBarConfigurations[wantedTab!]
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height: 50)
                Image("trent_beta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                
                Spacer()
                    .frame(height: 55)
                
                Text("Join the trent.")
                    .bold()
                    .italic()
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .tracking(1.5)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Spacer()
                
                SignInWithAppleButton(
                    onRequest: { request in
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = sha256(nonce)
                        
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                
                                guard let nonce = currentNonce else {
                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                }
                                guard let appleIDToken = appleIDCredential.identityToken else {
                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                }
                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                    return
                                }
                                
                                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString,rawNonce: nonce)
                                Auth.auth().signIn(with: credential) { (authResult, error) in
                                    if (error != nil) {
                                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                                        // you're sending the SHA256-hashed nonce as a hex string with
                                        // your request to Apple.
                                        print(error?.localizedDescription as Any)
                                        return
                                    }
                                    print("signed in")
                                    if(authResult?.additionalUserInfo?.isNewUser ?? false) {
                                        let firstName = appleIDCredential.fullName!.givenName!
                                        let lastName = appleIDCredential.fullName!.familyName!
                                        BackendClient.shared.createNewUser(firstName: firstName, lastName: lastName, mail: appleIDCredential.email!, uid: (authResult?.user.uid)!, completionHandler: { userObject in
                                            UserObjectManager.shared.user = userObject
                                            // here
                                            successfullyConcluded()
                                        })
                                        print("registered")
                                    } else {
                                        // here
                                        successfullyConcluded()
                                    }
                                }
                                
                                print("\(String(describing: Auth.auth().currentUser?.uid))")
                            default:
                                break
                                
                            }
                        default:
                            break
                        }
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(width: 275, height: 50)
                .cornerRadius(25)
                .padding(5)
                
                HStack {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 1)
                    Text("or")
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 1)
                }
                
                
                
                VStack {
                    if createNewAccount {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 5)
                                    .padding(.vertical, 0)
                                TextField("First Name", text: $firstName)
                                    .placeholder(when: firstName.isEmpty) { Text("First Name").foregroundColor(.init(.displayP3, white: 1, opacity: 0.7)) }
                                    .textContentType(.familyName)
                                    .disableAutocorrection(true)
                                    .autocapitalization(UITextAutocapitalizationType.none)
                                    .padding(.leading, 40)
                                    .padding(.trailing, 25)
                                    .padding(.vertical, 10)
                            }
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                                    .padding(.trailing, 20)
                                    .padding(.leading, 5)
                                    .padding(.vertical, 0)
                                TextField("Last Name", text: $lastName)
                                    .placeholder(when: lastName.isEmpty) { Text("Last Name").foregroundColor(.init(.displayP3, white: 1, opacity: 0.7)) }
                                    .textContentType(.givenName)
                                    .disableAutocorrection(true)
                                    .autocapitalization(UITextAutocapitalizationType.none)
                                    .padding(.trailing, 40)
                                    .padding(.leading, 25)
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 0)
                        TextField("Mail address", text: $mail)
                            .placeholder(when: mail.isEmpty) { Text("Mail address").foregroundColor(.init(.displayP3, white: 1, opacity: 0.7)) }
                            .textContentType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(UITextAutocapitalizationType.none)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 0)
                        SecureField("Password", text: $password)
                            .placeholder(when: password.isEmpty) { Text("Password").foregroundColor(.init(.displayP3, white: 1, opacity: 0.7)) }
                            .textContentType(createNewAccount ? .newPassword : .password)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                    }
                    if createNewAccount {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 0)
                            SecureField("Confirm Password", text: $confirmPassword)
                                .placeholder(when: confirmPassword.isEmpty) { Text("Confirm Password").foregroundColor(.init(.displayP3, white: 1, opacity: 0.7)) }
                                .textContentType(.newPassword)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                        }
                    }
                    Button(action: {
                        createNewAccount.toggle()
                    }, label: {
                        Text(createNewAccount ? "Already have an account?" : "Don't have an account yet?")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
//                            .tracking(1.3)
                    })
                }
                .foregroundColor(.white)
                .hidden(!useMail)
                .frame(height: useMail ? (createNewAccount ? 100 : 50) : 0)
                .padding([.top, .bottom], useMail ? (createNewAccount ? 60 : 40) : -20)
                
                Button(action: {
                    if !useMail {
                        useMail = true
                    } else {
                        if mail == "" || password == "" {
                            isShownEmptyAlert = true
                            return
                        }
                        if createNewAccount {
                            if firstName == "" || lastName == "" {
                                isShownEmptyAlert = true
                                return
                            }
                            if password != confirmPassword {
                                isShownPasswordAlert = true
                                return
                            }
                            isLoading = true
                            UserObjectManager.shared.createNewUser(firstName: firstName, lastName: lastName, mail: mail, password: password) { success in
                                isLoading = false
                                if !success {
                                    isShownFailureAlert = true
                                } else {
                                    successfullyConcluded()
                                }
                            }
                        } else {
                            isLoading = true
                            Auth.auth().signIn(withEmail: mail.lowercased(), password: password) { authResult, error in
                                isLoading = false
                                let success = (error == nil)
                                if !success {
                                    isShownSingInFailureAlert = true
                                } else {
                                    successfullyConcluded()
                                }
                            }
                        }
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 0.5)
                            .frame(width: 275, height: 50)
                            .foregroundColor(.white)
                        
                        if !isLoading {
                            Text(useMail ? "Sign \(createNewAccount ? "up" : "in") with mail" : "Use mail instead")
                                .foregroundColor(.white)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .colorInvert()
                        }
                    }
                    
                })
                .padding(5)
                
                Group {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Skip for now")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .tracking(1.3)
                    })
                    Spacer()
                        .frame(height: 20)
//                    Button {
//                        //
//                    } label: {
//                        Text("By singing up you confirm you have read our \(Text("Terms and Conditions").foregroundColor(.white)) and acceept them.")
//                            .font(.system(size: 10))
//                            .foregroundColor(.gray)
//                    }
                    Link(destination: URL(string: /*"https://trentapp.com/terms"*/"https://trentapp.com/AllgemeineNutzungsbedingungen.pdf")!) {
                        Text("By singing up you confirm you have read our \(Text("Terms and Conditions").foregroundColor(.white)) and acceept them.")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                
//                Spacer()
//                    .frame(height: 50)
            }
            .animation(animate ? .easeInOut(duration: 0.3) : .none)
        }
//        .onTapGesture {
//            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        }
        .alert(isPresented: $isShownPasswordAlert, content: {
            Alert(title: Text("Passwords don't match"), message: Text("Please make sure that you have entered the same password."), dismissButton: .default(Text("Okay")))
        })
        .alert(isPresented: $isShownFailureAlert, content: {
            Alert(title: Text("Could not log in"), message: Text("An error occured while loggin in. Please try again later."), dismissButton: .default(Text("Okay")))
        })
        .alert(isPresented: $isShownSingInFailureAlert, content: {
            Alert(title: Text("Could not log in"), message: Text("An error occured while loggin in. Please try again later."), primaryButton: .default(Text("Okay")), secondaryButton: .default(Text("Forgot password"), action: {
                FirebaseAuthClient.shared.forgotPassword(mail: mail) { success in
                    //
                }
            }))
        })
        .alert(isPresented: $isShownEmptyAlert, content: {
            Alert(title: Text("Empty fields"), message: Text("Please make sure to fill out all fields"), dismissButton: .default(Text("Okay")))
        })
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
