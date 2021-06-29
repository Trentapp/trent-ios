//
//  Transaction.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.06.21.
//

import Foundation

struct Transaction: Codable {
    var lender: String
    var borrower: String
    var item: String
    var start_date: String
    var end_date: String
    var granted: Int
    var total_price: Double
}
