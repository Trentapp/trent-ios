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
    
    var notificationFunction: (() -> Void)?
    
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location: \(locations.last?.coordinate)")
        self.currentLocation = locations.last
        if notificationFunction != nil {
            notificationFunction!()
            notificationFunction = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func notifyOnNextUpdate(completionHandler: @escaping () -> Void){
        if currentLocation != nil {
            completionHandler()
        } else {
            self.notificationFunction = completionHandler
        }
    }
}
