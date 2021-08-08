//
//  EditAccountView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 18.06.21.
//

import SwiftUI

struct EditAccountView: View {
    @State var name = UserObjectManager.shared.user?.name ?? ""
    
    @State var street = UserObjectManager.shared.user?.address?.street ?? ""
    @State var houseNumber = UserObjectManager.shared.user?.address?.houseNumber ?? ""
    @State var zipcode = UserObjectManager.shared.user?.address?.zipcode ?? ""
    @State var city = UserObjectManager.shared.user?.address?.city ?? ""
    @State var country = UserObjectManager.shared.user?.address?.country ?? ""
    
    @State var newPassword = ""
    @State var repeatNewPassword = ""
    
    @State var isUpdating = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
                Section(header: Text("Address")) {
                    TextField("Street", text: $street)
                    TextField("House number", text: $houseNumber)
                    TextField("Zipcode", text: $zipcode)
                    TextField("City", text: $city)
                    TextField("Country", text: $country)
                }
                Section(header: Text("Change Password")) {
                    SecureField("New Password", text: $newPassword)
                    SecureField("Repeat new password", text: $repeatNewPassword)
                }
                Section {
                    Button {
                        UserObjectManager.shared.deleteUser { success in
                            if !success {
                                // Tell the user
                            }
                        }
                    } label: {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }

                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
            .fontWeight(Font.Weight.regular)
        }), trailing: Button(action: {
            isUpdating = true
            BackendClient.shared.updateUserObject(name: name, street: street, houseNumber: houseNumber, zipcode: zipcode, city: city, country: country) { success in
                isUpdating = false
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    // Tell the user
                    print("Error updating user")
                }
            }
            
            if(newPassword != "" && newPassword == repeatNewPassword) {
                FirebaseAuthClient.shared.changePassword(newPassword: newPassword) { success in
                    if success {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        // TODO: provide information about failure
                        print("Error updating password")
                    }
                }
            }
        }, label: {
            if isUpdating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text("Save")
            }
        }))
        .onAppear() {
//            UITableView.appearance().backgroundColor = (colorScheme == .dark) ? UIColor.systemBackground : defaultTableViewBackgroundColor
//            UITableView.appearance().isScrollEnabled = true
        }
    }
}


struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView()
    }
}
