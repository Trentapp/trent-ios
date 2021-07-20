//
//  ChatView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import SwiftUI
import Introspect

struct ChatView: View {
    @State var chat: Chat
    @State var tabBar: UITabBar?
    
    @State var message = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView{
                    VStack(spacing: 10) {
                        ForEach(chat.messages , id: \.self) { message in
                            let isFromMe = (message.sender == UserObjectManager.shared.user?._id)
                            HStack {
                                if isFromMe { Spacer() }
                                    
                                HStack {
                                        Text(message.content)
                                            .foregroundColor(isFromMe ? .white : .black)
                                            .multilineTextAlignment(.leading)
                                            .padding(.vertical, 5)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 15)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(isFromMe ? .blue : Color(UIColor.lightGray)))
                                if !isFromMe { Spacer() }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                }
                ZStack {
                    //                Rectangle()
                    //                    .foregroundColor(.gray)
                    HStack {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.gray)
                            TextField("Message", text: $message)
                                .frame(width: geometry.size.width - 100)
                                .padding(.horizontal, 5)
                        }
                        .background(Color.white)
                        .padding(.horizontal, 10)
                        Button {
                            // Backendclient: sendMessage BackendClient.shared.sendMessage(chat_id: chat._id, content: message)
                            self.message = ""
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(.blue)
                                Image(systemName: "paperplane")
                                    .foregroundColor(.white)
                                    .padding(2)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                }
                .frame(height: 30)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitle(chat.borrower, displayMode: .inline)
        .ignoresSafeArea(.container, edges: .bottom)
        .introspectTabBarController { (UITabBarController) in
            self.tabBar = UITabBarController.tabBar
            self.tabBar?.isHidden = true
        }
        .onAppear() {
            self.tabBar?.isHidden = true
        }
    }
}
