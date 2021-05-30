//
//  ItemDetailView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 30.05.21.
//

import SwiftUI

struct ItemDetailView: View {
    @State var item: Product?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Rectangle()
                .frame(height: 250)
            
            HStack {
                Text(item?.name ?? "Untitled item")
                    .font(.system(size: 30, weight: .semibold, design: .default))
                    .padding(.horizontal, 15)
                Spacer()
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("\(String(format: "%.2f", round(100*(item?.prices?.perHour ?? 0))/100))€/hr")
                        .font(.system(size: 23, weight: .medium, design: .default))
                    HStack(alignment: .center, spacing: 0, content: {
//                        Text("5/5")
//                            .padding(.trailing, 5)
                        ForEach(Range(uncheckedBounds: (lower: 0, upper: 5))) { index in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                        }
                    })
                })
                
                    .padding(.horizontal, 15)
            }
            
            Divider()
                .padding(.bottom, 10)
            
            Text(item?.desc ?? "")
                .font(.system(size: 22, weight: .regular, design: .default))
                .padding(.horizontal, 15)
            
            Spacer()
        })
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)))
    }
}
