//
//  BookingModelView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 29.07.21.
//

import Foundation

class BookingModelView: ObservableObject {
    @Published var item: Product
    
    @Published var transaction: Transaction?
    
    @Published var creditCardHolder = ""
    @Published var creditCardNumber = ""
    @Published var cvv = ""
    @Published var expirationYear = 2021
    @Published var expirationMonth = 8
    
    init(item: Product) {
        self.item = item
    }
}
