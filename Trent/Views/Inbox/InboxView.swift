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
                    if transactions?.count ?? 0 != 0 {
                        Section(header: Text("Requests")) {
                            //                        if transactions?.count ?? 0 == 0 {
                            //                            Text("No requests yet")
                            //                                .foregroundColor(.gray)
                            //                        }
                            ForEach(transactions ?? [] , id: \.self) { transaction in
                                NavigationLink(
                                    destination: TransactionDetailView(transaction: transaction),
                                    label: {
                                        HStack{
                                            VStack(alignment: .leading) {
                                                Text(transaction.borrower?.name ?? "Borrower")
                                                    .bold()
                                                Text(transaction.product?.name ?? "Item")
                                            }
                                            Spacer()
                                            if transaction.status == 2 {
                                                Text("Accepted")
                                                    .foregroundColor(.green)
                                            } else if transaction.status == 1 {
                                                Text("Rejected")
                                                    .foregroundColor(.green)
                                            } else {
                                                if transaction.borrower?._id == UserObjectManager.shared.user?._id {
                                                    Text("Pending")
                                                        .foregroundColor(.gray)
                                                } else {
                                                    Button(action: {
                                                        BackendClient.shared.setTransactionStatus(transactionId: transaction._id, transactionStatus: 2) { success in
                                                            if !success {
                                                                // Tell user
                                                            }
                                                        }
                                                    }, label: {
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
                                                    Button(action: {
                                                        BackendClient.shared.setTransactionStatus(transactionId: transaction._id, transactionStatus: 1) { success in
                                                            if !success {
                                                                // Tell user
                                                            }
                                                        }
                                                    }, label: {
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
                                    })
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
                                    Text((chat.borrower?._id == UserObjectManager.shared.user?._id) ? (chat.lender?.name ?? "Lender" ) : (chat.borrower?.name ?? "Borrower" ) )
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
