//
//  CardRegistrationResult.swift
//  Trent
//
//  Created by Fynn Kiwitt on 17.08.21.
//

import Foundation

struct CardRegistrationResult: Codable {
    var PreregistrationData: String
    var CardRegistrationURL: String
    var AccessKey: String
    var CardRegistrationId: String
    
    var registrationURL: URL? {
        get {
            return URL(string: self.CardRegistrationURL)
        }
    }
}
