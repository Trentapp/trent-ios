//
//  ChatView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import SwiftUI
import Introspect

struct ChatView: View {
    @State var tabBar: UITabBar?
    
    var body: some View {
        Text("Super amazing chat!")
            .introspectTabBarController { (UITabBarController) in
                self.tabBar = UITabBarController.tabBar
                self.tabBar?.isHidden = true
            }
            .onAppear() {
                self.tabBar?.isHidden = true
            }
    }
}
