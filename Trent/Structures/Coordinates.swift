//
//  Coordinates.swift
//  Trent
//
//  Created by Fynn Kiwitt on 20.07.21.
//

import Foundation
import MapKit

struct Coordinates: Codable, Hashable {
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
