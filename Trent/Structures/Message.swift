//
//  Message.swift
//  Trent
//
//  Created by Fynn Kiwitt on 20.07.21.
//

import Foundation

struct Message: Codable, Hashable {
    var _id: String
    var timestamp: String?
    var sender: UserProfile?
    var content: String?
    var read: Bool?
}
