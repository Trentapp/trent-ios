//
//  DetailBottomView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct DetailBottomView: View {
    
    @ObservedObject var controler = MapViewController.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: controler.currentlyFocusedItem)) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(colorScheme == .dark ? Color(UIColor.systemGray4) : .white)
                    .frame(width: 300, height: 75)
                    .padding()
                    .shadow(radius: 3)
                HStack(alignment: .center, spacing: 10, content: {
                    Image(uiImage: controler.currentlyFocusedItem?.thumbnailUIImage ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 55, height: 55)
                    VStack(alignment: .leading, spacing: 0, content: {
                        Text(controler.currentlyFocusedItem?.name ?? "Untitled item")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(Color(UIColor.label))
                        Text(controler.currentlyFocusedItem?.desc ?? "")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                        Spacer()
                    })
                    Spacer()
    //                Text((item.prices?.pricePerHour == nil) ? ((item.prices?.pricePerDay == nil) ? "?/hr" : "\(item.prices?.pricePerDay!)/day") : item.prices?.pricePerHour!)
                    Text("\(Int(controler.currentlyFocusedItem?.prices?.perDay ?? 0))€/day")
                        .foregroundColor(Color(UIColor.label))
                })
                .frame(width: 280, height: 55)
                
            }
        }
        .hidden(controler.currentlyFocusedItem == nil)
        
    }
}

