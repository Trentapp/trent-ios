//
//  DashboardView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 01.07.21.
//

import SwiftUI

struct DashboardView: View {
    
    @State var name = UserObjectManager.shared.user?.name ?? "User"
    @State var query = ""
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Spacer()
                    NavigationLink(destination: AccountView()) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 30)
                    .padding([.top, .trailing], 15)
                }
                HStack {
                    Text("Hey \(name)")
                        .font(.system(size: 40, weight: .bold))
                        .padding()
                    Spacer()
                }
                
//                TextField("\(Image(systemName: "Lupe")) Search near", text: $query)
//
//                Spacer()
//                    .frame(height: 20)
//
//                Text("Upcoming")
//                    .font(.system(size: 20, weight: .bold))
//                ForEach(
                
                Spacer()
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
    }
}
