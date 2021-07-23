//
//  UserProfile.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import Foundation
import UIKit

struct UserProfile: Codable, Hashable {
    var _id: String
    var name: String?
    var inventory: [Product]?
    var rating: Double?
    var numberOfRatings: Int?
    var picture: Picture?
    
    var pictureUIImage: UIImage? {
        get {
            if picture == nil { return nil }
            let ui_picture = UIImage(data: picture!.data.convertedData as Data)
            return ui_picture
        }
    }
}
