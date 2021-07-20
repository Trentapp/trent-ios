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
    var thumbnail: String?
    var pictures: [Picture]?
    
    var thumbnailUIImage: UIImage? {
        get {
            let data = Data(base64Encoded: thumbnail ?? "")
            if data == nil { return nil }

            let image = UIImage(data: data!)
            return image
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
