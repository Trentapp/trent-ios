//
//  Review.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import Foundation

struct Review: Codable, Hashable {
    var _id: String
    var title: String
    var comment: String
    var poster: UserProfile
    var ratedUser: UserProfile
    var stars: Int
}
