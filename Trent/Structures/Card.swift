//
//  Card.swift
//  Trent
//
//  Created by Fynn Kiwitt on 09.09.21.
//

import Foundation

struct Card: Codable, Hashable {
    var Id: String
    var Active: Bool
    var ExpirationDate: String
    var Alias: String
    
    var expirationDateHR: String {
        get {
            let date = "\(ExpirationDate.prefix(2))/\(ExpirationDate.suffix(2))"
            return date
        }
    }
}
