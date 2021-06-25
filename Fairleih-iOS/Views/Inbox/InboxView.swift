//
//  InboxView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import SwiftUI

struct InboxView: View {
    
    @State var chats: [Chat]?
    @State var isLoading = true
    
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
                        Text(chat.lender)
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
            }
    }
}
