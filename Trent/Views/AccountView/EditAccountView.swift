//
//  EditAccountView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 18.06.21.
//

import SwiftUI

struct EditAccountView: View {
    @State var firstName = UserObjectManager.shared.user?.firstName ?? ""
    @State var lastName = UserObjectManager.shared.user?.lastName ?? ""
    
    @State var streetWithNr = UserObjectManager.shared.user?.address?.streetWithNr ?? ""
    @State var zipcode = UserObjectManager.shared.user?.address?.zipcode ?? ""
    @State var city = UserObjectManager.shared.user?.address?.city ?? ""
    @State var country = UserObjectManager.shared.user?.address?.country ?? ""
    
    @State var newPassword = ""
    @State var repeatNewPassword = ""
    
    @State var isUpdating = false
    @State var showError = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("First name", text: $firstName)
                        .textContentType(.givenName)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    TextField("Last name", text: $lastName)
                        .textContentType(.familyName)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                }
                Section(header: Text("Address [your address will be publicly visible]")) {
                    TextField("Street", text: $streetWithNr)
                        .textContentType(.streetAddressLine1)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    TextField("Zipcode", text: $zipcode)
                        .textContentType(.postalCode)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    TextField("City", text: $city)
                        .textContentType(.addressCity)
                    TextField("Country", text: $country)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .textContentType(.countryName)
                }
                Section(header: Text("Change Password")) {
                    SecureField("New Password", text: $newPassword)
                    SecureField("Repeat new password", text: $repeatNewPassword)
                }
                Section {
                    Button {
                        UserObjectManager.shared.deleteUser { success in
                            if !success {
                                showError = true
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
            BackendClient.shared.updateUserObject(firstName: firstName, lastName: lastName, streetWithNr: streetWithNr, zipcode: zipcode, city: city, country: country) { success in
                isUpdating = false
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    showError = true
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
        .alert(isPresented: $showError, content: {
            Alert(title: Text("Something went wrong"), message: Text("Please try again later."), dismissButton: .default(Text("Okay")))
        })
    }
}


struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView()
    }
}
