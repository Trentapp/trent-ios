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


struct Message: Codable, Hashable {
    var _id: String
    var timestamp: String
    var sender: String
    var content: String
    var read: Bool
}
