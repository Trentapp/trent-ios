//
//  TabBarController.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var mainViewProperties = MainViewProperties.shared
    @ObservedObject var userObjectManager = UserObjectManager.shared
    
    init() {
        defaultTableViewBackgroundColor = .secondarySystemBackground
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $mainViewProperties.selectedItem) {
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "map")
                    }
                    .tag(tabBarConfigurations[0])
                
                InventoryView()
                    .navigationBarTitle("Inventory")
                    .tabItem {
                        Label("Inventory", systemImage: "books.vertical")
                    }
                    .tag(tabBarConfigurations[1])
                    .navigationBarHidden(false)
                
                InboxView()
                    .tabItem {
                        Label("Inbox", systemImage: "tray.and.arrow.down")
                    }
                    .tag(tabBarConfigurations[2])
                    .navigationBarHidden(false)
                
                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person")
                    }
                    .tag(tabBarConfigurations[3])
            }
            .navigationBarTitle(mainViewProperties.selectedItem.title, displayMode: .large)
            .navigationBarHidden(mainViewProperties.selectedItem.hidden)
            .fullScreenCover(isPresented: $mainViewProperties.showAuthentication, content: { AuthenticationView(wantedTab: 3) })
            .onChange(of: mainViewProperties.selectedItem, perform: { value in
                if value.id == 3 && !UserObjectManager.shared.loggedIn {
                    mainViewProperties.showAuthentication = true
                    mainViewProperties.selectedItem = mainViewProperties.oldValue
                } else {
                    mainViewProperties.oldValue = mainViewProperties.selectedItem
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct NavigationBarConfiguration: Hashable {
    var title: String
    var hidden: Bool
    var id: Int
}
