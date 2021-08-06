//
//  InboxView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import SwiftUI
//import Introspect

struct InboxView: View {
    
    @State var chats: [Chat]?
    @State var transactions: [Transaction]?
    @State var isLoading = true
    
    @State var firstLoad = true
    
    @State private var selectedSection = 0
    
//    @State var tabBar: UITabBar?
    
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
                    Section(header: Text("Requests")) {
                        if transactions == nil {
                            Text("No requests yet")
                                .foregroundColor(.gray)
                        }
                        ForEach(transactions ?? [] , id: \.self) { transaction in
                            HStack{
                                VStack {
                                    Text(transaction.borrower?.name ?? "Borrower")
                                    Text(transaction.item?.name ?? "Item")
                                }
                                Spacer()
                                if transaction.status == 2 {
                                    Text("Accepted")
                                        .foregroundColor(.green)
                                } else if transaction.status == 1 {
                                    Text("Rejected")
                                        .foregroundColor(.green)
                                } else {
                                    Button(action: {}, label: {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(.green)
                                                .opacity(0.5)
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                        }
                                        .frame(width: 30, height: 30)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    Button(action: {}, label: {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(.red)
                                                .opacity(0.5)
                                            Image(systemName: "xmark")
                                                .foregroundColor(.red)
                                        }
                                        .frame(width: 30, height: 30)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Messages")) {
                        if chats == nil {
                            Text("No chats yet")
                                .foregroundColor(.gray)
                        }
                        ForEach(chats ?? [] , id: \.self) { chat in
                            NavigationLink(
                                destination: ChatView(chat: chat),
                                label: {
                                    Text(chat.lender?._id ?? "Lender")
                                })
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Inbox"), displayMode: .large)
        .navigationViewStyle(StackNavigationViewStyle())
//        .navigationBarHidden(false)
        .onAppear() {
            if firstLoad {
                firstLoad = false
                isLoading = true
                
                BackendClient.shared.getTransactionsAsLender { transactions in
                    isLoading = false
                    self.transactions = transactions
                }
                
                BackendClient.shared.getChats { chats in
                    isLoading = false
                    self.chats = chats
                }
            }
////            Backendclient: getChats BackendClient.shared.getChats { chats in
//                self.chats = nil //chats
//                isLoading = false
////            }
////            DispatchQueue.global().async {
//                // Backendclient getTransactionsAsLender let transactions = BackendClient.shared.getTransactionsAsLender()
//                let transactions: [Transaction]? = []
////                DispatchQueue.main.async {
//                    self.transactions = transactions
////                }
////            }
////            self.tabBar?.isHidden = false
        }
    }
}


//Picker(selection: $selectedSection, label: Text("Picker"), content: {
//    Text("Lenders").tag(0)
//    Text("Borrowers").tag(1)
//})
//.pickerStyle(SegmentedPickerStyle())
//.frame(width: 300)
