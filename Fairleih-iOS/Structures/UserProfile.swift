//
//  UserProfile.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import Foundation

struct UserProfile: Codable {
    var _id: String
    var name: String
    var inventory: [String]?
    var rating: Double?
    var numberOfRatings: Int?
}
