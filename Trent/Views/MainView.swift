//
//  TabBarController.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
            TabView {
                NavigationView {
                    MapView()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationViewStyle(StackNavigationViewStyle())
                }
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                
                
                NavigationView {
                    InventoryView()
                }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Inventory", systemImage: "books.vertical")
                    }
                
                
                NavigationView {
                    InboxView()
                }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Inbox", systemImage: "tray.and.arrow.down")
                    }
                
                
                NavigationView {
                    AccountView()
                        .navigationTitle("")
                        .navigationBarHidden(true)
//                        .navigationBarTitle("Account")
//                        .navigationBarHidden(false)
                }
                .navigationViewStyle(DefaultNavigationViewStyle())
                    .tabItem {
                        Label("Account", systemImage: "person")
                    }
            }
    }
}