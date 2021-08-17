//
//  Transaction.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.06.21.
//

import Foundation

struct Transaction: Codable, Hashable {
    var _id: String
    var lender: UserProfile?
    var borrower: UserProfile?
    var product: Product?
    var startDate: String?
    var endDate: String?
    var status: Int?
    var totalPrice: Int?
    var lenderEarnings: Int?
    var isPaid: Bool?
    
    var dateStartDate: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            let date = dateFormatter.date(from: self.startDate ?? "")
            return date
        }
    }
    
    var dateEndDate: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            let date = dateFormatter.date(from: self.endDate ?? "")
            return date
        }
    }
}
