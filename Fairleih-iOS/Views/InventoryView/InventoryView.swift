//
//  InventoryView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 30.05.21.
//

import SwiftUI

struct InventoryView: View {
    
    @State var inventory: [Product] = [Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)), Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)), Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)), Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)), Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)), Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)), Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20))]
    @State var showAddProduct = false
    
    var body: some View {
        
        ScrollView{
            VStack {
                Button(action: {
                    showAddProduct.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.green)
                        HStack {
                            ZStack{
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                Image(systemName: "plus")
                                    .font(.system(size: 15, weight: .bold, design: .default))
                                    .foregroundColor(.green)
                            }
                            Text("Add new item")
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                })
                .frame(height: 50)
                .padding()
                InventoryCollectionView(items: inventory)
                Spacer()
            }
        }
        .sheet(isPresented: $showAddProduct, content: { AddProductView() })
        .navigationTitle("Inventory")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
