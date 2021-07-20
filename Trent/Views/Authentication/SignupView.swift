////
////  SignupView.swift
////  Fairleih-iOS
////
////  Created by Fynn Kiwitt on 26.05.21.
////
//
//import SwiftUI
//import Firebase
//import AuthenticationServices
//import CryptoKit
//
//struct SignupView: View {
//    
//    @State var name = ""
//    @State var mail = ""
//    @State var password = ""
//    @State var password_confirmed = ""
//    
//    @State var isShownPasswordAlert = false
//    
//    @ObservedObject var userObjectManager = UserObjectManager.shared
//    
//    // Unhashed nonce.
//    @State var currentNonce: String?
//    
//    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
//    func randomNonceString(length: Int = 32) -> String {
//        precondition(length > 0)
//        let charset: Array<Character> =
//            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//        var result = ""
//        var remainingLength = length
//        
//        while remainingLength > 0 {
//            let randoms: [UInt8] = (0 ..< 16).map { _ in
//                var random: UInt8 = 0
//                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//                if errorCode != errSecSuccess {
//                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
//                }
//                return random
//            }
//            
//            randoms.forEach { random in
//                if remainingLength == 0 {
//                    return
//                }
//                
//                if random < charset.count {
//                    result.append(charset[Int(random)])
//                    remainingLength -= 1
//                }
//            }
//        }
//        
//        return result
//    }
//    
//    func sha256(_ input: String) -> String {
//        let inputData = Data(input.utf8)
//        let hashedData = SHA256.hash(data: inputData)
//        let hashString = hashedData.compactMap {
//            return String(format: "%02x", $0)
//        }.joined()
//        
//        return hashString
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20, content: {
//                Spacer()
//                    .frame(height:10)
//                TextField("name", text: $name)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .disableAutocorrection(true)
//                    .autocapitalization(.words)
//                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                TextField("mail address", text: $mail)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                SecureField("password", text: $password)
//                    .textContentType(.newPassword)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                SecureField("confirm password", text: $password_confirmed)
//                    .textContentType(.newPassword)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                
//                HStack{
//                    Spacer()
//                    Button("Sign up") {
//                        if(password == password_confirmed){
//                            UserObjectManager.shared.createNewUser(name: name, mail: mail, password: password)
//                        } else {
//                            isShownPasswordAlert.toggle()
//                        }
//                    }
//                    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                    
//                }
//                
//                SignInWithAppleButton(
//                    onRequest: { request in
//                        let nonce = randomNonceString()
//                        currentNonce = nonce
//                        request.requestedScopes = [.fullName, .email]
//                        request.nonce = sha256(nonce)
//                    },
//                    onCompletion: { result in
//                        switch result {
//                        case .success(let authResults):
//                            switch authResults.credential {
//                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
//                                
//                                guard let nonce = currentNonce else {
//                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                                }
//                                guard let appleIDToken = appleIDCredential.identityToken else {
//                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                                }
//                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                                    return
//                                }
//                                
//                                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
//                                Auth.auth().signIn(with: credential) { (authResult, error) in
//                                    if (error != nil) {
//                                        // Error. If error.code == .MissingOrInvalidNonce, make sure
//                                        // you're sending the SHA256-hashed nonce as a hex string with
//                                        // your request to Apple.
//                                        print(error?.localizedDescription as Any)
//                                        return
//                                    }
//                                    print("signed in")
//                                    // Backendclient: createNewUser BackendClient.shared.createNewUser(name: appleIDCredential.fullName!.description, mail: appleIDCredential.email!, uid: (authResult?.user.uid)!)
//                                }
//                                
//                                print("\(String(describing: Auth.auth().currentUser?.uid))")
//                            default:
//                                break
//                                
//                            }
//                        default:
//                            break
//                        }
//                    }
//                )
//                .frame(width: 280, height: 45)
//                Spacer()
//                
//                HStack {
//                    Spacer()
//                    NavigationLink("Already have an Account?", destination: LoginView())
//                    Spacer()
//                }
//                .padding(.bottom, -20)
//                
//                NavigationLink("", destination: MainView().navigationBarHidden(true), isActive: $userObjectManager.loggedIn).hidden()
//            })
//            
//            .alert(isPresented: $isShownPasswordAlert, content: {
//                Alert(title: Text("Passwords don't match"), message: Text("Please make sure that you have entered the same password."), dismissButton: .default(Text("Okay")))
//            })
//            
//            .navigationTitle("Sign up")
//            .navigationBarHidden(false)
//            .navigationBarTitleDisplayMode(.large)
//        }
//    }
//}
//
//
//struct Signup_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupView()
//    }
//}
