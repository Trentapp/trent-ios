//
//  MapAnnotationButton.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct MapAnnotationButton: View {
    static var currentFocused: MapAnnotationButton? = nil
    
    @State var item: Product
    @State var focused = false
        
    var body: some View {
        
        Button {
            MapAnnotationButton.currentFocused?.focused = false
            MapAnnotationButton.currentFocused = self
            focused = true
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 12.5)
                    .foregroundColor(focused ? .black : .white)
                    .frame(width: 50, height: 25)
                Text("\(Int(item.prices?.perDay ?? 0))€")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(focused ? .white : .black)
            }
            
        }
        
    }
    
}
