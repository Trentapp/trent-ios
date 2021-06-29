//
//  InboxView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import SwiftUI
import Introspect

struct InboxView: View {
    
    @State var chats: [Chat]?
    @State var isLoading = true
    
    @State private var selectedSection = 0
    
    @State var tabBar: UITabBar?
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if (chats ?? []).isEmpty {
                Text("No new messages")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(chats ?? [] , id: \.self) { chat in
                        NavigationLink(
                            destination: ChatView(),
                            label: {
                                Text(chat.lender)
                            })
                    }
                    
                }
            }
        }
        .navigationBarTitle("Inbox", displayMode: .large)
        .onAppear() {
            BackendClient.shared.getChats { chats in
                self.chats = chats
                isLoading = false
            }
            self.tabBar?.isHidden = false
        }
        .introspectTabBarController { (UITabBarController) in
            self.tabBar = UITabBarController.tabBar
        }
    }
}


//Picker(selection: $selectedSection, label: Text("Picker"), content: {
//    Text("Lenders").tag(0)
//    Text("Borrowers").tag(1)
//})
//.pickerStyle(SegmentedPickerStyle())
//.frame(width: 300)
