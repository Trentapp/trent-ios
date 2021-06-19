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
                    TextField("New Password", text: $newPassword)
                    TextField("Repeat new password", text: $repeatNewPassword)
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
                    print("Error updating user")
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
    }
}


struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView()
    }
}
