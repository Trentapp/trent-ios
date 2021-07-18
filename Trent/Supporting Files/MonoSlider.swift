//
//  MonoSlider.swift
//  Trent
//
//  Created by Fynn Kiwitt on 16.07.21.
//

import SwiftUI

struct MonoSlider: View {
    var width: CGFloat
    
    @Binding var maxValue: CGFloat
    
    @State private var maxDelta: CGFloat = 0
    
    var maxDrag: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { gesture in
                self.maxValue = (width - min((-1) * min(0, maxDelta + gesture.translation.width), width - 12.5)) / width
            }
            .onEnded { gesture in
                maxDelta = (self.maxValue * width - width)
            }
    }
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.gray)
                    .frame(width: width, height: 2)
                HStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.blue)
                        .frame(width: width - (-1) * ( self.maxValue * width - width), height: 4)
                        .overlay(
                            HStack {
                                Spacer()
                                Circle()
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                    .frame(width: 27.5, height: 27.5)
                                    .gesture(maxDrag)
                            }
                        )
                    Spacer()
                        .frame(width: (-1) * (self.maxValue * width - width))
                }
                .frame(width: width)
                
            }
    }
}

