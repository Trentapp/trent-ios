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
    
    @Environment(\.colorScheme) var colorScheme
    
    func search(){
        UIApplication.shared.endEditing()
        showMap = true
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.gray)
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorScheme == .dark ? Color(UIColor.systemGray4) : .white))
                    .frame(height: 60, alignment: .center)
                    .shadow(radius: 5)
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                TextField("What are you looking for?", text: $keyword, onEditingChanged: { editing in
                                    print("editing: \(editing)")
                                }, onCommit: {
                                    search()
                                })
                                .foregroundColor((self.keyword == "") ? .gray : Color(UIColor.label))
                                .font(.system(size: 17, weight: .semibold, design: .default))
                                .multilineTextAlignment(.leading)
                                //                            .frame(width: 250, height: 20, alignment: .center)
                                .padding(.trailing, 15)
                                
                            }
                            .frame(height: 60)
                        }
                        
                    )
                    .padding(.leading, 10)
                
                Spacer()
                    .frame(width: 10)
                
                Button {
                    search()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.init(red: 121/255, green: 121/255, blue: 121/255, opacity: 1))
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 23, weight: .bold))
                            .frame(width: 50, height: 50)
                    }
                        .padding(5)
                }
                
            }
            
            Spacer()
            Text("Explore new items")
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


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
