//
//  CollectionView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 01.06.21.
//

import SwiftUI

struct InventoryCollectionView: View {
    
    @State var items: [Product]
    @State var screenWidth: Double = 300
    
    var body: some View {
        VStack {
            ForEach((0..<Int(CGFloat(items.count) / 2)), id: \.self){ i in
                HStack {
                    ForEach((0..<2), id: \.self){ j in
                        InventoryItemView(item: items[2*i+j])
                            .frame(height: 250)
                            .shadow(radius: 10)
                            .padding()

                    }
                }
            }
        }
    }
}
