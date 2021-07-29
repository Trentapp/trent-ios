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
    @Published var ccv = ""
    @Published var expirationYear: String?
    @Published var expirationMonth: String?
    
    init(item: Product) {
        self.item = item
    }
}
