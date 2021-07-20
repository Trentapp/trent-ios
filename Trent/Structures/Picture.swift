//
//  Picture.swift
//  Trent
//
//  Created by Fynn Kiwitt on 20.07.21.
//

import Foundation

struct Picture: Codable, Hashable {
    var _id: String
    var data: ByteData
}

struct ByteData: Codable, Hashable{
    var data: [UInt8]
    var convertedData: NSData {
        get {
            let nsdata = NSData(bytes: data, length: data.count)
//            let data = Data(nsdata)
            return nsdata
        }
    }
}
