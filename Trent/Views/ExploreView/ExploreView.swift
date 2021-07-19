//
//  ExploreView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 18.07.21.
//

import SwiftUI

struct ExploreView: View {
    
    @State var keyword = ""
    @State var showMap = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 0.5)
                .foregroundColor(.gray)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .frame(width: 375, height: 60, alignment: .center)
                .shadow(radius: 5)
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 15)
                            TextField("\(Image(systemName: "magnifyingglass"))  What are you looking for?", text: $keyword, onEditingChanged: { editing in
                                print("editing: \(editing)")
                            }, onCommit: {
                                UIApplication.shared.endEditing()
                                print("Did commit: \(keyword)")
                                showMap = true
                            })
                            .foregroundColor((self.keyword == "") ? .gray : .black)
                            .font(.system(size: 17, weight: .semibold, design: .default))
                            .multilineTextAlignment(.leading)
                            //                            .frame(width: 250, height: 20, alignment: .center)
                            .padding(5)
                            
                        }
                        .frame(width: 375, height: 60)
                    }
                    
                )
            Spacer()
            NavigationLink(destination: MapView(keyword: keyword), isActive: $showMap) {
                EmptyView()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
