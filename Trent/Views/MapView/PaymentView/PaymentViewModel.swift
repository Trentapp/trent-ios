//
//  PaymentViewModel.swift
//  Trent
//
//  Created by Fynn Kiwitt on 17.08.21.
//

import Foundation

class PaymentViewModel: ObservableObject {
    @Published var transaction: Transaction?
    @Published var totalPrice: Double = 0
    
    @Published var creditCardHolder = ""
    @Published var creditCardNumber = ""
    @Published var cvx = ""
    @Published var expirationYear = 2021
    @Published var expirationMonth = 8
    
    var expirationDate: String {
        get {
            let month = String(format: "%02d", expirationMonth)
            let year = String(expirationYear)
            let yearAbb = year.suffix(2)
            return month + yearAbb
        }
    }
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
}
