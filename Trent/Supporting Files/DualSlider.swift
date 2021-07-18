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
    
    @State private var minDelta: CGFloat
    @State private var maxDelta: CGFloat
    
    init(minValue: Binding<CGFloat>, maxValue: Binding<CGFloat>, width: CGFloat) {
        self._minValue = minValue
        self._maxValue = maxValue
        self.width = width
        
        self.minDelta = minValue.wrappedValue
        self.maxDelta = maxValue.wrappedValue
    }
    
    var minDrag: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { gesture in
                self.minValue = min(max(0, minDelta + gesture.translation.width), self.maxValue * width - 10) / width
                print("actual: \(max(0, minDelta + gesture.translation.width)); limited: \(self.maxValue * width - 54), total: \(self.minValue * width)")
            }
            .onEnded { gesture in
                minDelta = self.minValue * width
            }
    }
    
    var maxDrag: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { gesture in
                self.maxValue = (width - min((-1) * min(0, maxDelta + gesture.translation.width), width - self.minValue * width - 10)) / width
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
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.black, lineWidth: 0.2)
                                    .background(RoundedRectangle(cornerRadius: 2).foregroundColor(.white))
//                                    .shadow(radius: 3)
                                    .frame(width: 5, height: 27.5)
                                    .gesture(minDrag)
                                
                                Spacer()
                                    .frame(minWidth: 0)
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.black, lineWidth: 0.2)
                                    .background(RoundedRectangle(cornerRadius: 2).foregroundColor(.white))
//                                    .shadow(radius: 3)
                                    .frame(width: 5, height: 27.5)
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
