//
//  AccountView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct AccountView: View {
    
    @ObservedObject var userObjectManager = UserObjectManager.shared
//    @State var image = UIImage(systemName: "person.crop.circle")!
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
            Text(userObjectManager.user.name)
                .font(.largeTitle)
                .bold()
            List{
                HStack{
                    Text("Edit Profile")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .listStyle(GroupedListStyle())
//            Spacer()
        }
    }
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
