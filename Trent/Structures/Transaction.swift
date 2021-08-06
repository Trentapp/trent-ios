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
    var item: Product?
    var startDate: String?
    var endDate: String?
    var status: Int?
    var totalPrice: Double?
}
