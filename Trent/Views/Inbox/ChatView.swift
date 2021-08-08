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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView{
                    VStack(spacing: 10) {
                        ForEach(chat.messages , id: \.self) { message in
                            let isFromMe = (message.sender?._id == UserObjectManager.shared.user?._id)
                            HStack {
                                if isFromMe { Spacer() }
                                    
                                HStack {
                                        Text(message.content ?? "")
                                            .foregroundColor(isFromMe ? .white : Color(UIColor.label))
                                            .multilineTextAlignment(.leading)
                                            .padding(.vertical, 5)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 15)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(isFromMe ? .blue : Color(UIColor.systemGray3)))
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
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.gray)
                            .overlay(
                                TextField("Message", text: $message)
                                    .padding(.horizontal, 5)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(colorScheme == .dark ? Color(UIColor.systemGray4) : .white)
                                )
                            .frame(width: geometry.size.width - 75)
                            .padding(.leading, 10)
                        Button {
                            BackendClient.shared.sendMessage(chat_id: chat._id, content: message) { success in
                                if !success {
                                    // tell user
                                }
                                self.message = ""
                                BackendClient.shared.getChat(chatId: self.chat._id) { chat in
                                    if chat != nil {
                                        self.chat = chat!
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 30)
                                Image(systemName: "paperplane")
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                            }
                            .padding(.trailing, 7)
                            
                        }
                    }
                }
                .frame(height: 35)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitle((chat.borrower?._id == UserObjectManager.shared.user?._id) ? (chat.lender?.name ?? "Lender" ) : (chat.borrower?.name ?? "Borrower" ), displayMode: .inline)
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
