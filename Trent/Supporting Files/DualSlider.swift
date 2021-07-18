//
//  DualSlider.swift
//  Trent
//
//  Created by Fynn Kiwitt on 15.07.21.
//

import SwiftUI

struct DualSlider: View {
    var width: CGFloat
    
    @Binding var minValue: CGFloat
    @Binding var maxValue: CGFloat
    
    @State private var minDelta: CGFloat = 0
    @State private var maxDelta: CGFloat = 0
    
    var minDrag: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { gesture in
                self.minValue = min(max(0, minDelta + gesture.translation.width), width - self.maxValue - 50) / width
            }
            .onEnded { gesture in
                minDelta = self.minValue * width
            }
    }
    
    var maxDrag: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { gesture in
                self.maxValue = (width - min((-1) * min(0, maxDelta + gesture.translation.width), width - self.minValue - 50)) / width
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
                    Spacer()
                        .frame(width: self.minValue * width)
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.blue)
                        .frame(width: width - self.minValue * width - (-1) * ( self.maxValue * width - width), height: 4)
                        .overlay(
                            HStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                    .frame(width: 27.5, height: 27.5)
                                    .gesture(minDrag)
                                
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
