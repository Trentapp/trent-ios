//
//  AddProductView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    @State var description = ""
    @State var priceHour = ""
    @State var priceDay = ""
    
    @State var street = ""
    @State var houseNumber = ""
    @State var zipcode = ""
    @State var city = ""
    @State var country = ""
    
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10, content: {
                TextField("Name", text: $name)
                    .padding(.horizontal, 10)
                TextField("Description", text: $description)
                    .padding(.horizontal, 10)
                    .keyboardType(.numbersAndPunctuation)
                TextField("Price per hour", text: $priceHour)
                    .padding(.horizontal, 10)
                    .keyboardType(.numbersAndPunctuation)
                TextField("Price per hour", text: $priceDay)
                    .padding(.horizontal, 10)
                TextField("street", text: $street)
                    .padding(.horizontal, 10)
                    .textContentType(.streetAddressLine1)
                TextField("houseNumber", text: $houseNumber)
                    .padding(.horizontal, 10)
                TextField("zipcode", text: $zipcode)
                    .padding(.horizontal, 10)
                    .textContentType(.postalCode)
                TextField("city", text: $city)
                    .padding(.horizontal, 10)
                    .textContentType(.addressCity)
                TextField("country", text: $country)
                    .padding(.horizontal, 10)
                    .textContentType(.countryName)
                Button {
                    let address: [String : Any] = [
                        "street" : street,
                        "houseNumber" : houseNumber,
                        "zipcode" : Int(zipcode) ?? 00000,
                        "city" : city,
                        "country" : country
                    ]
                    
                    let location = [
                        "lat" : 48,
                        "lng" : 7.5
                    ]
                    
                    var prices: [String : Any] = [:]
                    
                    if let priceHourNumber = Double(priceHour) {
                        prices["perHour"] = priceHourNumber
                    }
                    
                    if let priceDayNumber = Double(priceDay) {
                        prices["perDay"] = priceDayNumber
                    }
                    
                    let parameters: [String : Any] = [
                        "name" : name,
                        "desc" : description,
                        "address" : address,
                        "location" : location,
                        "prices" : prices
                    ]
                    
                    print("parameters: \(parameters)")
                    
                    BackendClient.shared.postNewItem(parameters: parameters) { successful in
                        print("successful: \(successful)")
                        if successful {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showAlert = true
                        }
                    }
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.blue)
                            .frame(height: 30)
                        Text("Publish")
                            .foregroundColor(.white)
                    }
                }
                .padding(.all, 10)

            })
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("An error occured when trying to add your item. Please try again later."), dismissButton: .default(Text("Cancel")))
            }
        
            
            .navigationBarTitle("Add Product", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel", action: {}))
        }
    }
}
