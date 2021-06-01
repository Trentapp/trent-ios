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
                
                Button {
                    
                    var prices: [String : Any] = [:]
                    
                    if let priceHourNumber = Double(priceHour) {
                        prices["perHour"] = priceHourNumber
                    }
                    
                    if let priceDayNumber = Double(priceDay) {
                        prices["perDay"] = priceDayNumber
                    }
                    
                    let address = UserObjectManager.shared.user?.address
                    
                    let parameters: [String : Any] = [
                        "name" : name,
                        "desc" : description,
                        "address" : address,
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
