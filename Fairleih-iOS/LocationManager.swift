//
//  LocationManager.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published public var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1500, longitudinalMeters: 1500)
    
    private override init() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func updateLocation(){
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location: \(locations.last?.coordinate)")
        self.currentLocation = locations.last ?? nil
        self.coordinateRegion = MKCoordinateRegion(center: self.currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1500, longitudinalMeters: 1500)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
