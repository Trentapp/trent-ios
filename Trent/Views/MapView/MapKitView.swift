//
//  MapKitView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 24.07.21.
//

import SwiftUI
import MapKit

struct MapKitView: UIViewRepresentable {
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var region: MKCoordinateRegion
    @Binding var annotationItems: [Product]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.region = region
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.userTrackingMode = userTrackingMode
        uiView.region = region
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var mapKitView: MapKitView
        
        init(_ mapKitView: MapKitView){
            self.mapKitView = mapKitView
        }
        
        func updateMapKitView(sender: MKMapView) {
            mapKitView.region = sender.region
            mapKitView.userTrackingMode = sender.userTrackingMode
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            updateMapKitView(sender: mapView)
        }
    }
}
