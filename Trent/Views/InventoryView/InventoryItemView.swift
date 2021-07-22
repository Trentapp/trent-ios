//
//  InventoryItemView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 01.06.21.
//

import SwiftUI

struct InventoryItemView: View {
    
    @State var showEditProduct = false
    @State var item: Product?
    
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: item), label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.white)
                VStack(alignment: .center, spacing: 10, content: {
                    //                        Image(uiImage: item?.thumbnailUIImage ?? UIImage())
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.black)
                    HStack {
                        Text(item?.name ?? "Untitled item")
                            .bold()
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("\(String(format: "%.2f", round(100*(item?.prices?.perHour ?? 0))/100))€/hr")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.black)
                    }
                })
                .padding()
            }
            
        })
        .contextMenu(ContextMenu(menuItems: {
            if(item?.user?._id == UserObjectManager.shared.user?._id) {
                Button( action: { self.showEditProduct.toggle() },
                        label: {
                            Text("Edit")
                            Image(systemName: "pencil")
                        })
                
                Button(action: {
                    let item_id = item?._id ?? ""
                    BackendClient.shared.deleteProduct(with: item_id) { success in
                        if !success {
                            // Tell the user it failed
                        }
                    }
                }, label: {
                    Text("Delete")
                        .foregroundColor(.red)
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                })
            }
        }))
        .sheet(isPresented: $showEditProduct, content: { AddProductView(item: item) })
    }
}
