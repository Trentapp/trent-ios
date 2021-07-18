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
                                        let name = appleIDCredential.fullName!.givenName! + " " + appleIDCredential.fullName!.familyName!
                                        BackendClient.shared.createNewUser(name: name, mail: appleIDCredential.email!, uid: (authResult?.user.uid)!)
                                        print("registered")
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
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 0.5)
                            .frame(width: 275, height: 50)
                            .foregroundColor(.white)
                        
                        Text("Sign up with mail")
                            .foregroundColor(.white)
                    }
                    
                })
                .padding(5)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Skip for now")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .tracking(1.3)
                })
                
                Spacer()
                    .frame(height: 50)
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
