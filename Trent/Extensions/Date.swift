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
}
