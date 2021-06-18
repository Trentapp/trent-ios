//
//  InventoryItemView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 01.06.21.
//

import SwiftUI

struct InventoryItemView: View {
    
    @State var item: Product?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
            VStack(alignment: .center, spacing: 10, content: {
//                Image(uiImage: item?.thumbnailUIImage ?? UIImage())
                RoundedRectangle(cornerRadius: 10)
                Text(item?.name ?? "Untitled item")
                    .bold()
                    .multilineTextAlignment(.leading)
                HStack {
                    Spacer()
                    Text("\(String(format: "%.2f", round(100*(item?.prices?.perHour ?? 0))/100))€/hr")
                        .multilineTextAlignment(.trailing)
                }
            })
            .padding()
        }
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {
                BackendClient.shared.deleteProduct(with: item?._id ?? "")
            }, label: {
                Text("Delete")
                    .foregroundColor(.red)
                Image(systemName: "trash")
                    .foregroundColor(.red)
            })
        }))
    }
}
