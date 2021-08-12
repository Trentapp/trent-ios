//
//  InventoryItemView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 01.06.21.
//

import SwiftUI

struct InventoryItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var showEditProduct = false
    @State var showError = false
    var item: Product?
    
    var body: some View {
        NavigationLink(destination: ItemDetailView(item: item!), label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(colorScheme == .dark ? Color(UIColor.systemGray4) : .white)
                    .shadow(radius: 10)
                VStack(alignment: .center, spacing: 10, content: {
                    Image(uiImage: item?.thumbnailUIImage ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(.black)
                    HStack {
                        Text(item?.name ?? "Untitled item")
                            .bold()
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("\(String(format: "%.2f", round((item?.prices?.perDay ?? 0))/100))€/day")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color(UIColor.label))
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
                            showError = true
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
        .alert(isPresented: $showError, content: {
            Alert(title: Text("Something went wrong"), message: Text("Please try again later."), dismissButton: .default(Text("Okay")))
        })
    }
}
