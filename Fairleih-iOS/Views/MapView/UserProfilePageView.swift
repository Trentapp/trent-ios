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
    @State var updated = false
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 5)
                
                HStack(alignment: .center, spacing: 2, content: {
                    Text("\((userProfile?.rating ?? 0) == 0 ? "-" : "\((userProfile?.rating)!)")/5")
                    Spacer()
                        .frame(width: 5)
                    ForEach(Range(uncheckedBounds: (lower: 0, upper: 5))) { index in
                        let isStarFilled = (index+1) <= Int(round((userProfile?.rating) ?? 0))
                        Image(systemName: isStarFilled ? "star.fill" : "star")

                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.yellow)
                            .frame(width: 20, height: 20)
                    }
                    Spacer()
                })
                .padding(.horizontal, 20)
                
                HStack {
                    NavigationLink(
                        destination: ReviewView(userProfile: userProfile),
                        label: {
                            Text("See \(userProfile?.numberOfRatings ?? 0) Reviews")
                        })
                    Spacer()
                }
                .hidden((userProfile?.numberOfRatings ?? 0) == 0)
                .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 10)
                
                InventoryCollectionView(items: $inventory)
                Spacer()
            }
        }
            .navigationBarTitle(userProfile?.name ?? "User Profile", displayMode: .large)
            .onAppear(){
                if !updated {
                    self.inventory = BackendClient.shared.getInventory(inventory: userProfile?.inventory ?? [])
                    self.updated = true
                }
            }
    }
}
