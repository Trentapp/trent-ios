//
//  UserProfile.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import Foundation

struct UserProfile: Codable, Hashable {
    var _id: String
    var name: String?
    var inventory: [Product]?
    var rating: Double?
    var numberOfRatings: Int?
}
