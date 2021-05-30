//
//  MapAnnotationButton.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct MapAnnotationButton: View {
    static var currentlyFocused: MapAnnotationButton? {
        didSet {
            MapViewController.shared.currentlyFocusedItem = MapAnnotationButton.currentlyFocused?.item
        }
    }
    
    @State var item: Product
    @State var focused = false {
        
        willSet {
            if !focused && MapAnnotationButton.currentlyFocused?.focused != nil {
                MapAnnotationButton.currentlyFocused?.focused = false
            }
        }
        
        didSet{
            if(focused) {
                MapAnnotationButton.currentlyFocused = self
            }
        }
        
    }
        
    var body: some View {
        
        Button {
            focused = true
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 12.5)
                    .foregroundColor(focused ? .black : .white)
                    .frame(width: 50, height: 25)
                Text("\(Int(item.prices?.perHour ?? 0))€")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(focused ? .white : .black)
            }
            
        }
        
    }
    
}
