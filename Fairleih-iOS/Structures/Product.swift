//
//  Product.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 27.05.21.
//

import Foundation
import MapKit

struct Product: Codable, Identifiable {
    let id = UUID()
    var _id: String
    var user_id: String
    var name: String?
    var desc: String?
    var address: Address?
    var location: Coordinates?
    var prices: Prices?
    var thumbnail: String?
    var pictures: [String]?
    
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
            
            for base64String in pictures! {
                let data = Data(base64Encoded: base64String)
                if data == nil { continue }
                
                let image = UIImage(data: data!)
                if image == nil { continue }
                images.append(image!)
            }
            
            return images
        }
    }
}

struct Prices: Codable {
    var perHour: Double?
    var perDay: Double?
}

struct Address: Codable {
    var street: String
    var houseNumber: String
    var zipcode: String
    var city: String
    var country: String
}

struct Coordinates: Codable {
    var coordinates: [Double]
    
    var CLcoordinates: CLLocationCoordinate2D {
        get {
            if coordinates.count == 2 {
                return CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
            }
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}
