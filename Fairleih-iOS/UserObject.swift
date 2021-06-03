//
//  User.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 31.05.21.
//

import Foundation

struct UserObject: Codable {
    var name: String
    var mail: String
    var inventory: [String]
    var address: Address
}
