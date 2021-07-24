//
//  AddAddressView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 23.07.21.
//

import SwiftUI

struct AddAddressView: View {
    
    @State var street = ""
    @State var houseNumber = ""
    @State var zipcode = ""
    @State var city = ""
    @State var country = "Germany"
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @ObservedObject var isKeyboardShown = KeyboardManager.shared
//    {
//        didChange {
//            UITableView.appearance().isScrollEnabled = KeyboardManager.shared.isKeyboardShown
//        }
//    }
//    .isKeyboardShown {
//        didSet {
//            UITableView.appearance().isScrollEnabled = KeyboardManager.shared.isKeyboardShown
//        }
//    }
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().isScrollEnabled = false
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Text("Before you add your first product please tell us your address. This way we know for which people your products are relevant.")
                    Section {
                        TextField("Street", text: $street)
                            .textContentType(.streetAddressLine1)
                        TextField("House number", text: $houseNumber)
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
                    //
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.blue)
                            .frame(height: 50)
                        Text("Set address")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                }
                
            }
            
            .ignoresSafeArea(.keyboard)
            .navigationBarTitle("Add your address", displayMode: .large)
        }
    }
}
