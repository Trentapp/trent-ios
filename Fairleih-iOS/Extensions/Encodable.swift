//
//  CodableAsDictonary.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 19.06.21.
//

import Foundation

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
