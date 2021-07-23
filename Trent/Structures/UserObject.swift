//
//  User.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 31.05.21.
//

import Foundation
import UIKit

struct UserObject: Codable {
    var _id: String
    var name: String?
    var mail: String?
    var inventory: [String]?
    var address: Address?
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
