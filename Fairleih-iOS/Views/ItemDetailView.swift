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
        Text(item?.name ?? "Untitled item")
    }
}
