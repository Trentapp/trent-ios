//
//  Address.swift
//  Trent
//
//  Created by Fynn Kiwitt on 20.07.21.
//

import Foundation

struct Address: Codable, Hashable {
    var streetWithNr: String?
    var zipcode: String?
    var city: String?
    var country: String?
    
    var firstLine: String {
        get {
            return streetWithNr ?? "Street 0"
        }
    }
    
    var secondLine: String {
        get {
            return (zipcode ?? "000000") + " " + (city ?? "City")
        }
    }
    
    var thirdLine: String {
        get {
            return country ?? "Country"
        }
    }
}
