//
//  UserProfilePageView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import SwiftUI

struct UserProfilePageView: View {
    
    @State var userProfile: UserProfile?
    @State var inventory = [Product]()
    
    var body: some View {
        ScrollView {
            VStack{
                InventoryCollectionView(items: $inventory)
                Spacer()
            }
        }
            .navigationBarTitle(userProfile?.name ?? "User Profile", displayMode: .large)
            .onAppear(){
                self.inventory = BackendClient.shared.getInventory(inventory: userProfile?.inventory ?? [])
            }
    }
}
