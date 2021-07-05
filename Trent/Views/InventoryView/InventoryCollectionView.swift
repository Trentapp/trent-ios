//
//  CollectionView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 01.06.21.
//

import SwiftUI

struct InventoryCollectionView: View {
    
    @Binding var items: [Product]
    @State var numberOfItemsPerRow = max(2, Int(UIScreen.screenWidth / 200))
    
    var body: some View {
        if (items.count > 0){
            VStack {
                ForEach((0..<Int(ceil(CGFloat(items.count) / CGFloat(numberOfItemsPerRow)))), id: \.self){ i in
                    HStack {
                        ForEach((0..<numberOfItemsPerRow), id: \.self){ j in
                            if (2*i+j) < items.count{
                                InventoryItemView(item: items[2*i+j])
                                    .frame(height: 250)
                                    .shadow(radius: 10)
                                    .padding()
                            } else {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(height: 250)
                                    .padding()
                            }
                        }
                    }
                }
            }
        } else {
            Spacer()
                .frame(height: 50)
            Text("No products yet")
                .foregroundColor(Color.gray)
        }
        
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
