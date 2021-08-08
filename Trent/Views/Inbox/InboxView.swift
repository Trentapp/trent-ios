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
    
    func refresh() {
        BackendClient.shared.getTransactions { transactions in
            isLoading = false
            self.transactions = transactions?.reversed()
        }
        
        BackendClient.shared.getChats { chats in
            isLoading = false
            self.chats = chats
        }
    }
    
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
                                                Text((transaction.borrower?._id == UserObjectManager.shared.user?._id) ? (transaction.lender?.name ?? "Lender" ) : (transaction.borrower?.name ?? "Borrower" ))
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
                                                            refresh()
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
                                                        refresh()
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
                                    HStack {
//                                        (chat.borrower?._id == UserObjectManager.shared.user?._id) ? ((chat.lender?.pictureUIImage != nil) ? Image(uiImage: (chat.lender?.pictureUIImage)!) : Image(systemName: "person.crop.circle")) : ((chat.borrower?.pictureUIImage != nil) ? Image(uiImage: (chat.borrower?.pictureUIImage)!) : Image(systemName: "person.crop.circle"))
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .opacity((chat.borrower?._id == UserObjectManager.shared.user?._id) ? ((chat.lender?.pictureUIImage != nil) ? 1 : 0.5) : ((chat.borrower?.pictureUIImage != nil) ? 1 : 0.5))
//                                            .clipShape(Circle())
//                                            .foregroundColor(.gray)
//                                            .frame(width: 50, height: 50)
//                                            .padding()
                                        Text((chat.borrower?._id == UserObjectManager.shared.user?._id) ? (chat.lender?.name ?? "Lender" ) : (chat.borrower?.name ?? "Borrower" ))
                                    }
                                })
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Inbox"), displayMode: .large)
        .navigationViewStyle(StackNavigationViewStyle())
//        .navigationBarItems( trailing:
//            Button(action: {
//                BackendClient.shared.getTransactions { transactions in
//                    isLoading = false
//                    self.transactions = transactions?.reversed()
//                }
//
//                BackendClient.shared.getChats { chats in
//                    isLoading = false
//                    self.chats = chats
//                }
//            }, label:{
//                Text("refrsh")
////                Image(systemName: "arrow.counterclockwise")
//            })
//        )
        //        .navigationBarHidden(false)
        .onAppear() {
//            UITableView.appearance().isScrollEnabled = true
            if firstLoad {
                firstLoad = false
                isLoading = true
                
                refresh()
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
