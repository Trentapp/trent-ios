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
            MapView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            AccountView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
