//
//  Transaction.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.06.21.
//

import Foundation

struct Transaction: Codable, Hashable {
    var lender: String?
    var borrower: String?
    var item: String?
    var startDate: String?
    var endDate: String?
    var status: Int?
    var totalPrice: Double?
}
