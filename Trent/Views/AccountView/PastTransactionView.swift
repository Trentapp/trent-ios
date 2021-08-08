//
//  PastTransactionViewe.swift
//  Trent
//
//  Created by Fynn Kiwitt on 08.08.21.
//

import SwiftUI

struct PastTransactionView: View {
    @State var transactions: [Transaction]?
    @State var isLoading = true
    
    @State var firstLoad = true
    
    @State private var selectedSection = 0
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if (transactions ?? []).isEmpty {
                Text("No transactions yet.")
                    .foregroundColor(.gray)
            } else {
                List {
                    if transactions?.count ?? 0 != 0 {
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
                                        Text(transaction.dateStartDate?.hrStringDateOnly ?? "Start date")
                                            .foregroundColor(.gray)
                                    }
                                })
                        }
                    } else {
                    }
                }
            }
        }
        .navigationBarTitle(Text("Past Transactions"), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
//            UITableView.appearance().isScrollEnabled = true
            if firstLoad {
                firstLoad = false
                isLoading = true
                
                BackendClient.shared.getPastTransactions { transactions in
                    isLoading = false
                    self.transactions = transactions?.reversed()
                }
            }
        }
    }
}
