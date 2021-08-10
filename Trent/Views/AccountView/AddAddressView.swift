//
//  AddAddressView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 23.07.21.
//

import SwiftUI

struct AddAddressView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var streetWithNr = ""
    @State var zipcode = ""
    @State var city = ""
    @State var country = "Germany"
    
    @State var isLoading = false
    
    @State var showSetButton = true
    @State var keyboardResponder: KeyboardResponder?
    
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Text("Before you add your first product please tell us your address. This way we know for which people your products are relevant.")
                    Section {
                        TextField("Street", text: $streetWithNr)
                            .textContentType(.streetAddressLine1)
                        TextField("Zipcode", text: $zipcode)
                            .textContentType(.postalCode)
                        TextField("City", text: $city)
                            .textContentType(.addressCity)
                        TextField("Country", text: $country)
                            .textContentType(.countryName)
                    }
                }
                Button {
                    isLoading = true
                    BackendClient.shared.updateUserObject(name: UserObjectManager.shared.user?.name ?? "", streetWithNr: streetWithNr, zipcode: zipcode, city: city, country: country) { success in
                        isLoading = false
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.blue)
                            .frame(height: showSetButton ? 50 : 0)
                        Text("Set address")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                }
                .disabled(isLoading)
                .frame(height: showSetButton ? 50 : 0)
                
            }
            .navigationBarTitle("Add your address", displayMode: .large)
            .navigationBarItems(trailing:
                ZStack {
                    if isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle()).hidden(!isLoading)
                    } else {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Cancel")
                                .fontWeight(Font.Weight.regular)
                        })
                    }
                    
                }
            )
            .onAppear(){
//                UITableView.appearance().isScrollEnabled = true
//                UITableView.appearance().backgroundColor = .clear
                
                self.keyboardResponder = KeyboardResponder { isShown in
                    self.showSetButton = !isShown
                }
            }
        }
    }
}
