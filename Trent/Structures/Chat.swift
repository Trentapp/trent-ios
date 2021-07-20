//
//  Chat.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import Foundation

struct Chat: Codable, Hashable {
    var _id: String
    var lender: String
    var borrower: String
    var item: Product
    var messages: [Message]
}
