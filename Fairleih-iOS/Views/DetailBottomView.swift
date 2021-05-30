//
//  DetailBottomView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct DetailBottomView: View {
    
    @ObservedObject var controler = MapViewController.shared
    
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: controler.currentlyFocusedItem)) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 75)
                    .padding()
                HStack(alignment: .center, spacing: 10, content: {
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 55, height: 55)
                        .foregroundColor(.black)
                    VStack(alignment: .leading, spacing: 0, content: {
                        Text(controler.currentlyFocusedItem?.name ?? "Untitled item")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.black)
                        Text(controler.currentlyFocusedItem?.desc ?? "")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                        Spacer()
                    })
                    Spacer()
    //                Text((item.prices?.pricePerHour == nil) ? ((item.prices?.pricePerDay == nil) ? "?/hr" : "\(item.prices?.pricePerDay!)/day") : item.prices?.pricePerHour!)
                    Text("\(Int(controler.currentlyFocusedItem?.prices?.perHour ?? 0))€/hr")
                        .foregroundColor(.black)
                })
                .frame(width: 280, height: 55)
                
            }
        }
        .hidden(controler.currentlyFocusedItem == nil)
        
    }
}

