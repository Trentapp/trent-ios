//
//  AccountView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct AccountView: View {
    
    @State var name = UserObjectManager.shared.user?.name ?? "user name"
//    @State var image = UIImage(systemName: "person.crop.circle")!
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
            Text(name)
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
//            Spacer()
        }
    }
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
