//
//  TabBarController.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct MainView: View {
    
    @State var selectedItem = NavigationBarConfiguration(title: "Map", hidden: true, id: 0)
    @State var oldValue = NavigationBarConfiguration(title: "Map", hidden: true, id: 0)
    @ObservedObject var userObjectManager = UserObjectManager.shared
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedItem) {
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "map")
                    }
                    .tag(NavigationBarConfiguration(title: "Map", hidden: true, id: 0))
                
                InventoryView()
                    .navigationBarTitle("Inventory")
                    .tabItem {
                        Label("Inventory", systemImage: "books.vertical")
                    }
                    .tag(NavigationBarConfiguration(title: "Inventory", hidden: false, id: 1))
                    .navigationBarHidden(false)
                
                InboxView()
                    .tabItem {
                        Label("Inbox", systemImage: "tray.and.arrow.down")
                    }
                    .tag(NavigationBarConfiguration(title: "Inbox", hidden: false, id: 2))
                    .navigationBarHidden(false)
                
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person")
                    }
                    .tag(NavigationBarConfiguration(title: "Account", hidden: true, id: 3))
            }
            .navigationBarTitle(self.selectedItem.title, displayMode: .large)
            .navigationBarHidden(self.selectedItem.hidden)
            .fullScreenCover(isPresented: $userObjectManager.showAuthentication, content: { AuthenticationView() })
            .onChange(of: self.selectedItem, perform: { value in
                if value.id == 3 && !UserObjectManager.shared.loggedIn {
                    userObjectManager.showAuthentication = true
                    self.selectedItem = oldValue
                } else {
                    self.oldValue = selectedItem
                }
            })
        }
    }
}


struct NavigationBarConfiguration: Hashable {
    var title: String
    var hidden: Bool
    var id: Int
}
