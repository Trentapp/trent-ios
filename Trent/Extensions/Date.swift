//
//  Date.swift
//  Trent
//
//  Created by Fynn Kiwitt on 31.07.21.
//

import Foundation

extension Date {
    var iso8601: String {
        get {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            let dateAsISO8601 = formatter.string(from: self)
            return dateAsISO8601
        }
    }
    
    var hrString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, E d MMM y"
        let hrString = formatter.string(from: self)
        return hrString
    }
    
    var hrStringDateOnly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM y"
        let hrString = formatter.string(from: self)
        return hrString
    }
}
