//
//  AccountView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct AccountView: View {
    
    @State var showAddProduct = false
    
    var body: some View {
        Button("Offer new item") {
            showAddProduct.toggle()
        }
        .sheet(isPresented: $showAddProduct, content: { AddProductView() })
    }
}
