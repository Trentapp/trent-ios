//
//  BookingModelView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 29.07.21.
//

import Foundation

class BookingModelView: ObservableObject {
    @Published var item: Product
    
//    @Published var transaction: Transaction?
    
    @Published var totalPrice: Double = 0
    
    @Published var startDate = Date()
    @Published var endDate = Date()
    
    var duration: Int {
        get {
            return Int(max(ceil((startDate.distance(to: endDate) - 59) / (86400)), 0))
        }
    }
    
    @Published var creditCardHolder = ""
    @Published var creditCardNumber = ""
    @Published var cvv = ""
    @Published var expirationYear = 2021
    @Published var expirationMonth = 8
    
//    @Published var isBookingFinished = false
    
    init(item: Product) {
        self.item = item
    }
}
