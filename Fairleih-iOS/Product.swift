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
    var name: String?
    var desc: String?
    var address: Address?
    var location: Coordinates?
    var prices: Prices?
}

struct Prices: Codable {
    var perHour: Double
    var perDay: Double
}

struct Address: Codable {
    var street: String
    var houseNumber: String
    var zipcode: String
    var city: String
    var country: String
}

struct Coordinates: Codable {
    var lat: Double
    var lng: Double
    
    var coordinates: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
    }
}
