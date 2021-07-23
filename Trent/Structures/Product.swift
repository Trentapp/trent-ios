//
//  Product.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 27.05.21.
//

import Foundation
import UIKit

struct Product: Codable, Hashable, Identifiable {
    let id = UUID()
    var _id: String
    var user: UserProfile?
    var name: String?
    var desc: String?
    var address: Address?
    var location: Coordinates?
    var prices: Prices?
    var thumbnail: Picture?
    var pictures: [Picture]?
    
    var thumbnailUIImage: UIImage? {
        get {
            if thumbnail == nil { return nil }
            let ui_thumbnail = UIImage(data: thumbnail!.data.convertedData as Data)
            return ui_thumbnail
        }
    }

    var picturesUIImage: [UIImage] {
        get {
            if pictures == nil || pictures?.count == 0 { return [] }

            var images: [UIImage] = []

            for picture in pictures! {
                let image = UIImage(data: picture.data.convertedData as Data)
                if image == nil { continue }
                images.append(image!)
            }

            return images
        }
    }
}
