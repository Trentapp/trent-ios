//
//  InventoryView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 30.05.21.
//

import SwiftUI

struct InventoryView: View {
    
    @ObservedObject var userObjectManager = UserObjectManager.shared
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
                InventoryCollectionView(items: $userObjectManager.inventory)
                Spacer()
            }
        }
        .sheet(isPresented: $showAddProduct, content: { AddProductView() })
        .navigationTitle("Inventory")
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            UserObjectManager.shared.refresh()
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
