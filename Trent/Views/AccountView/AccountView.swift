//
//  AccountView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct AccountView: View {
    
    @ObservedObject var userObjectManager = UserObjectManager.shared
    @State var isShownLogOutAlert = false
//    @State var image = UIImage(systemName: "person.crop.circle")!
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
            Text(userObjectManager.user?.name ?? "")
                .font(.largeTitle)
                .bold()
            List{
                Section {
                    ZStack{
                        Button(""){}
                        NavigationLink("Edit Profile", destination: EditAccountView())
                    }
                }
                Section {
                    HStack{
                        Spacer()
                        Button(action: {
                            self.isShownLogOutAlert.toggle()
                        }, label: {
                            Text("Log out")
                                .foregroundColor(.red)
                        })
                        Spacer()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .alert(isPresented: $isShownLogOutAlert, content: {
                Alert(title: Text("Log out"), message: Text("Are you sure you want to log out of your current account? You will need to log back in with your password to gain access to your account again on this device."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Log out"), action: {
                    FirebaseAuthClient.shared.logOut()
                }))
            })
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        //                        .navigationBarTitle("Account")
        //                        .navigationBarHidden(false)
        .navigationViewStyle(DefaultNavigationViewStyle())
    }
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
